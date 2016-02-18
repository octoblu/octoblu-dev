fse        = require 'fs-extra'
handlebars = require 'handlebars'
path       = require 'path'
_          = require 'lodash'
dashdash   = require 'dashdash'

composeTemplatePath = path.join(__dirname, 'templates', 'docker-compose-template.yml')
envTemplatePath = path.join(__dirname, 'templates', 'env-template')

templateCompose = handlebars.compile(fse.readFileSync composeTemplatePath, 'utf8')
templateEnv = handlebars.compile(fse.readFileSync envTemplatePath, 'utf8')

defaultStackEnv = "#{process.env.HOME}/Projects/Octoblu/the-stack-env-production/dev.d/octoblu"

parser = dashdash.createParser
  options:
    [{
      names: ['project', 'p']
      type: 'string'
      help: 'The project for which you want to generate a docker-compose.yml (required)'
     }, {
      names: ['domain', 'd']
      type: 'string'
      help: 'The third level domain name aka container_name to use for Træfik'
     }, {
      names: ['stack-env', 's']
      type: 'string'
      help: "Stack environment directory to read from, default: #{defaultStackEnv}"
      default: defaultStackEnv
     }, {
      names: ['no-defaults', 'n']
      type: 'bool'
      help: 'Do not read from {{--stack-env}}/_defaults/env'
     }, {
      names: ['help', 'h'],
      type: 'bool',
      help: 'Print this help and exit.'
    }]

options = parser.parse process.argv

if !options.project?
  options.help = true

if options.help
  help = parser.help({includeEnv: true}).trimRight()
  console.error 'usage:'
  console.error help
  process.exit(0)

options.domain ?= options.project?.replace(/-service$/,"")

templateData =
  projectName: options.project
  domainName: options.domain
  env: []

environment = { DOCKER_COMPOSE_GENERATE_TIME: new Date }

readFile = (file) =>
  return if file.stats.isDirectory()
  name = _.last file.path.split('/')
  value = _.trim fse.readFileSync file.path, 'utf8'
  environment[name] = value

readEnv = (path, callback) =>
  fse.walk path
    .on 'data', readFile
    .on 'error', callback
    .on 'end', callback

writeData = () =>
  outputPath = path.join __dirname, "output"
  fse.mkdirpSync outputPath
  for name, value of environment
    templateData.env.push { name, value }
  fse.writeFileSync path.join(outputPath, "#{templateData.domainName}-compose.yml"), templateCompose(templateData)
  fse.writeFileSync path.join(outputPath, "#{templateData.domainName}.env"), templateEnv(templateData)
  console.log "wrote output/#{templateData.domainName}-compose.yml"
  console.log "wrote output/#{templateData.domainName}.env"

writeProjectEnv = () =>
  readEnv "#{options.stack_env}/#{templateData.projectName}/env", writeData

writeAllEnv = () =>
  readEnv "#{options.stack_env}/_defaults/env", writeProjectEnv

if options.no_defaults == true
  writeProjectEnv()
else
  writeAllEnv()
