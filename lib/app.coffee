#
{EventEmitter} = require 'events'
fs = require 'fs'
path = require 'path'
express = require 'express'
debug = require 'debug'
Promise = require 'promise'
yaml = require 'js-yaml'


#
autoLoadResources = (app)->
  try
    dir = app.resourceRoot
    resources = fs.readdirSync dir
    app.debug 'Auto loading resources %j from %s', resources, dir
    for resource in resources
      app.debug 'Loading %s', path.resolve dir, resource, resource
      r = require path.resolve dir, resource, resource
      try
        r( app)
        app.debug 'Resouce [%s] has loaded', resource
      catch err
        app.debug 'Error loading resouce [%s]', resource
        app.debug '\t[ ERROR ] %j', err

    return resources
  catch err
    false


#
loadApplicationDescriptor = (file)->
  try
    yaml.safeLoad fs.readFileSync file, 'utf8'
  catch e
    debug e
    false


#
class HttpApp extends EventEmitter

  #
  debug: debug 'roq:httpapp'

  #
  constructor: (options)->
    super

    #
    {@app,@port,@resourceRoot} = options if options

    #
    @app ?= express()
    @resourceRoot = path.resolve @resourceRoot if @resourceRoot
    @resourceRoot ?= path.resolve process.cwd(), 'resources'

    #
    @resources = autoLoadResources @

    #
    config_path = path.resolve( process.cwd(), process.env.ROQ_HTTPAPP_CONFIG) or path.resolve( process.cwd(), 'config.yml')
    @debug 'Loading application configuration from [%s]', config_path
    @config = loadApplicationDescriptor config_path


    console.log @config
  #
  route: ()->
    @app.use.apply @app, arguments

  #
  listen: (port=@port)->
    new Promise (pass,fail)=>
      @app.listen port, ()=>
        @debug 'Application changed state to [LISTENING] on port [%s]', port
        pass()

  #
  close: ()->
    new Promise (pass,fail)=>
      @app.close ()=>
        @debug 'Application changed state to [NOT LISTENING]'
      pass()
#
module.exports = (options)->
  new HttpApp options
