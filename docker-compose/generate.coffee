fse        = require 'fs-extra'
handlebars = require 'handlebars'
path       = require 'path'
_          = require 'lodash'
dashdash   = require 'dashdash'

templatePath = path.join(__dirname, 'docker-compose-template.yml')
template = handlebars.compile(fse.readFileSync templatePath, 'utf8')

parser = dashdash.createParser
  options:
    [{
      names: ['project', 'p']
      type: 'string'
      help: 'The project for which you want to generate a docker-compose.yml'
     }, {
      names: ['domain', 'd']
      type: 'string'
      help: 'The domain name you want to use when generating a docker-compose.yml'
    }, {
      names: ['help', 'h'],
      type: 'bool',
      help: 'Print this help and exit.'
    }]

options = parser.parse process.argv

options.domain ?= options.project.replace(/-service$/,"")

templateData =
  projectName: options.project
  domainName: options.domain
  env: []

if (options.help)
  help = parser.help({includeEnv: true}).trimRight()
  console.log 'usage:'
  console.log help
  process.exit(0)

fse.walk "/Users/octoblu/Projects/Octoblu/the-stack-env-production/major.d/octoblu/#{templateData.projectName}/env"
  .on 'data', (file) =>
    return unless file.stats.nlink == 1
    fileName = _.last file.path.split('/')
    contents = _.trim fse.readFileSync file.path, 'utf8'
    templateData.env.push {name:fileName, value:contents}

  .on 'end', =>
    outputPath = path.join(__dirname, "output", templateData.projectName)
    fse.mkdirpSync outputPath
    fse.writeFileSync path.join(__dirname, "output", templateData.projectName, "docker-compose.yml"), template(templateData)
    console.log 'done'
