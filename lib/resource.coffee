#
fs   = require 'fs'
debug = require 'debug'
yaml = require 'js-yaml'
{Router} = require 'express'


#
loadResourceDescriptor = (file)->
  try
    yaml.safeLoad fs.readFileSync file, 'utf8'
  catch e
    debug e
    false

#
class HttpResource

  #
  debug: debug 'roq:httpresource'

  #
  constructor: (context,options)->

    #
    {@app,@resource} = options if options

    #
    @debug 'HttpResource with descriptor %s', @resource

    #
    @descriptor = loadResourceDescriptor @resource

    #
    @router = new Router
      caseSensitive: false
      mergeParams: true
      strict: false

    #
    @routesFromDescriptor @descriptor, context

    #
    @app.route @descriptor.base, @router if @router.stack.length
    @debug 'Router created with %d routes', @router.stack.length

  #
  routesFromDescriptor: (descriptor=@descriptor, context=@)->
    @debug 'HttpResource creating routes'

    for r,m of descriptor.routes
      [verb, path] = r.split ' '

      @debug 'parsing route [%s %s]', verb, path

      continue if typeof context[m] isnt 'function'
      continue if typeof @router[ verb.toLowerCase()] isnt 'function'

      @router[ verb.toLowerCase()] path, context[m] verb
      @debug '\tadded route'

module.exports = (context, options)->
  new HttpResource context, options

#
module.exports.HttpResource = HttpResource
