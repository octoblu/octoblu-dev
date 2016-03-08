fse        = require 'fs-extra'
handlebars = require 'handlebars'
path       = require 'path'
_          = require 'lodash'
dashdash   = require 'dashdash'

composeTemplatePath = path.join(__dirname, '..', 'templates', 'docker-compose-template.yml')
envTemplatePath = path.join(__dirname, '..', 'templates', 'env-template')

templateCompose = handlebars.compile(fse.readFileSync composeTemplatePath, 'utf8')
templateEnv = handlebars.compile(fse.readFileSync envTemplatePath, 'utf8')

defaultStackEnv = "#{process.env.HOME}/Projects/Octoblu/the-stack-env-production/dev.d/octoblu"

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
      names: ['container', 'c']
      type: 'string'
      help: 'The third level container name aka container_name to use for Træfɪk'
     }, {
      names: ['dns', 'd']
      type: 'string'
      help: 'Address to use for resolving DNS'
      default: '127.0.0.1'
     }, {
      names: ['stack-env', 's']
      type: 'string'
      help: "Stack environment directory to read from, default: #{defaultStackEnv}"
      default: defaultStackEnv
     }, {
      names: ['links', 'l']
      type: 'arrayOfString'
      help: 'External links in format `docker-host[:as-host]`'
      default: []
     }, {
      names: ['compose', 'o']
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

options = {}
try
  options = parser.parse process.argv
catch error
  options.help = true

if options.json?
  options.json = '/dev/stdin' if options.json == '-'
  options = _.merge JSON.parse(fse.readFileSync options.json, 'utf8'), options

if !options.project?
  options.help = true

if options.help
  help = parser.help({includeEnv: true}).trimRight()
  console.error 'usage:'
  console.error help
  process.exit(0)

options.container ?= options.project?.replace(/-service$/,"")

templateData =
  projectName: options.project
  containerName: options.container
  compose: options.compose
  links: options.links
  dns: options.dns
  env: []

readFileEnv = (environment) =>
  return (file) =>
    return if file.stats.isDirectory()
    name = _.last file.path.split('/')
    value = _.trim fse.readFileSync file.path, 'utf8'
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

privateEnvPath=path.join  "#{options.stack_env}", "#{templateData.projectName}", "env"
publicEnvPath=path.join __dirname, '..', 'env', "#{templateData.projectName}"
defaultsPath=path.join __dirname, '..', 'env', '_defaults'

composeFile="#{templateData.projectName}-compose.yml"
publicEnvFile="#{templateData.projectName}-public.env"
privateEnvFile="#{templateData.projectName}-private.env"

writeProjectEnv = (environment) =>
  readEnv publicEnvPath, environment, parseEnv(templateData.env, (env) =>
    outputPath = path.join __dirname, '..', 'output'
    fse.mkdirpSync outputPath

    fse.writeFileSync path.join(outputPath, composeFile), templateCompose(templateData)
    console.log "wrote output/#{composeFile}"

    fse.writeFileSync path.join(outputPath, publicEnvFile), templateEnv({env})
    console.log "wrote output/#{publicEnvFile}"

    readEnv privateEnvPath, {}, parseEnv([], (env) =>
      fse.writeFileSync path.join(outputPath, privateEnvFile), templateEnv({env})
      console.log "wrote output/#{privateEnvFile}"
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
