path = require 'path'
{HttpResource} = require '../../../index'
debug = require('debug') 'roq:resource:user'

#
class RestfulMethodEnum

  #
  create: (verb)->
    [
      (req,res,next)=>
        res.status(200).json
    ]

  read: ()->
    (req,res,next)=>
      res.status(200).json

  update: ()->
    (req,res,next)=>
      res.status(200).json

  delete: ()->
    (req,res,next)=>
      res.status(200).json


#
class UserResource extends HttpResource

  methods: new RestfulMethods

  constructor: (app)->
    #
    super @methods,
      app: app
      resource: path.resolve __dirname, 'resource.yml'

    # #
    # @router.param 'user', (req,res,next,id)->
    #   req.param.user = id
    #   next()

  #






module.exports = (app)->
  debug 'Creating HttpResource'
  new UserResource app
