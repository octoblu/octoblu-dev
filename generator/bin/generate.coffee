#!/usr/bin/env coffee
fs         = require 'fs'
fse        = require 'fs-extra'
handlebars = require 'handlebars'
path       = require 'path'
_          = require 'lodash'
dashdash   = require 'dashdash'

defaultStackEnv = "#{process.env.HOME}/Projects/Octoblu/the-stack-env-production/dev/etcd/octoblu"
defaultOutputDir = "#{process.env.HOME}/Projects/Octoblu/octoblu-dev/services/generated"

parser = dashdash.createParser
  options:
    [{
      names: ['json', 'j']
      type: 'string'
      help: 'JSON file to read options from'
     }, {
      names: ['project', 'p']
      type: 'string'
      help: 'The project for which you want to generate a docker-compose.yml (required)'
     }, {
      names: ['container', 'i']
      type: 'string'
      help: 'The third level container name aka container_name to use for Træfɪk'
     }, {
      names: ['stack-env', 's']
      type: 'string'
      help: "Stack environment directory to read from, default: #{defaultStackEnv}"
      default: defaultStackEnv
     }, {
      names: ['output-dir', 'o']
      type: 'string'
      help: "Output parent directory to write files to, default: #{defaultOutputDir}"
      default: defaultOutputDir
     }, {
      names: ['links', 'l']
      type: 'arrayOfString'
      help: 'External links in format `docker-host[:as-host]`'
      default: []
     }, {
      names: ['compose', 'c']
      type: 'arrayOfString'
      help: 'Docker-Compose statements'
      default: []
     }, {
      names: ['environment', 'e']
      type: 'arrayOfString'
      help: 'Environment `key=value` pairs'
      default: []
     }, {
      names: ['no-defaults', 'n']
      type: 'bool'
      help: 'Do not read from {{--stack-env}}/_defaults/env'
     }, {
      names: ['help', 'h'],
      type: 'bool',
      help: 'Print this help and exit.'
    }]

generate = (options)=>
  if !options.project?
    options.help = true

  if options.help
    help = parser.help({includeEnv: true}).trimRight()
    console.error 'usage:'
    console.error help
    process.exit(0)

  options.dockerFileCmd ?= "node command.js"
  options.container ?= options.project?.replace(/-service$/,"")

  templateData =
    dockerFileInstructions: options.dockerFileInstructions
    dockerFileCmd: options.dockerFileCmd
    containerName: options.container
    projectName: options.project
    compose: options.compose
    links: options.links
    env: []

  readFileEnv = (environment) =>
    return (file) =>
      return if file.stats.isDirectory()
      name = _.last file.path.split('/')
      value = _.trim fs.readFileSync file.path, 'utf8'
      environment[name] = value

  readEnv = (path, environment, callback) =>
    doCallback = () => callback(environment)
    fse.walk path
      .on 'data', readFileEnv(environment)
      .on 'error', doCallback
      .on 'end', doCallback

  parseEnv = (envArray, callback) =>
    return (environment) =>
      for name, value of environment
        envArray.push {name, value}
      callback(envArray)

  privateEnvPath=path.join  options.stack_env, templateData.projectName, 'env'
  publicEnvPath=path.join __dirname, '..', 'public-env', templateData.projectName
  defaultsPath=path.join __dirname, '..', 'public-env', '_defaults'

  composeFile="#{templateData.projectName}-compose.yml"
  composeLocalFile="#{templateData.projectName}-compose-local.yml"
  dockerDevFile="#{templateData.projectName}.dockerfile-dev"
  publicEnvFile="#{templateData.projectName}-public.env"
  privateEnvFile="#{templateData.projectName}-private.env"

  composeTemplatePath = path.join(__dirname, '..', 'templates', 'docker-compose-template.yml')
  composeLocalTemplatePath = path.join(__dirname, '..', 'templates', 'docker-compose-local-template.yml')
  envTemplatePath = path.join(__dirname, '..', 'templates', 'env-template')
  dockerTemplatePath = path.join(__dirname, '..', 'templates', 'dockerfile-devs', dockerDevFile)

  hasDockerFile = true
  try
    fs.accessSync(dockerTemplatePath,fs.R_OK)
  catch error
    hasDockerFile = false

  if !hasDockerFile
    dockerTemplatePath = path.join(__dirname, '..', 'templates', 'template.dockerfile-dev')

  templateCompose = handlebars.compile(fs.readFileSync composeTemplatePath, 'utf8')
  templateComposeLocal = handlebars.compile(fs.readFileSync composeLocalTemplatePath, 'utf8')
  templateEnv = handlebars.compile(fs.readFileSync envTemplatePath, 'utf8')
  templateDocker = handlebars.compile(fs.readFileSync dockerTemplatePath, 'utf8')

  writeProjectEnv = (environment) =>
    readEnv publicEnvPath, environment, parseEnv(templateData.env, (env) =>
      outputPath = path.join options.output_dir, templateData.projectName
      fse.mkdirpSync outputPath

      fs.writeFileSync path.join(outputPath, composeFile), templateCompose(templateData)
      console.log "wrote #{templateData.projectName}/#{composeFile}"

      fs.writeFileSync path.join(outputPath, composeLocalFile), templateComposeLocal(templateData)
      console.log "wrote #{templateData.projectName}/#{composeLocalFile}"

      fs.writeFileSync path.join(outputPath, dockerDevFile), templateDocker(templateData)
      console.log "wrote #{templateData.projectName}/#{dockerDevFile}"

      fs.writeFileSync path.join(outputPath, publicEnvFile), templateEnv({env})
      console.log "wrote #{templateData.projectName}/#{publicEnvFile}"

      readEnv privateEnvPath, {}, parseEnv([], (env) =>
        fs.writeFileSync path.join(outputPath, privateEnvFile), templateEnv({env})
        console.log "wrote #{templateData.projectName}/#{privateEnvFile}"
      )
    )

  writeDefaultsEnv = (environment) =>
    readEnv defaultsPath, environment, writeProjectEnv

  initialEnvironment = {}
  for env in options.environment
    [key,value] = env.split(/=(.+)?/)
    initialEnvironment[key]=value

  if options.no_defaults == true
    writeProjectEnv(initialEnvironment)
  else
    writeDefaultsEnv(initialEnvironment)

#-------------------------------------------------------------------------------

options = {}
try
  options = parser.parse process.argv
catch error
  options.help = true

if !options.json?
  generate options
else
  options.json = process.stdin.fd if options.json == '-'
  jsonOptions = JSON.parse(fs.readFileSync options.json, 'utf8')
  if ! _.isArray jsonOptions
    jsonOptions = [ jsonOptions ]

  for jsonOption in jsonOptions
    generate _.merge jsonOption, options
