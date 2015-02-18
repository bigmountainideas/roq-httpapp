{HttpApp} = require '../index'

randomPort = ->
  parseInt (Math.random() * 8000) + 4000


describe 'HttpApp', ()->

  describe 'init', ()->

    it 'should listen when port set through constructor', (done)->

      app = new HttpApp port: randomPort()
      app.listen().then ()->
        done()

    it 'should listen when port passed as arg', (done)->

      app = new HttpApp
      app.listen(randomPort()).then ()->
        done()

    it 'should autoload resources', (done)->

      app = new HttpApp resourceRoot: './test/resources'
      done()

  describe 'cleanup', ()->

    it 'should stop accepting new connections', (done)->

      @timeout 10000
      app = new HttpApp port: randomPort()
      app.listen().then ()->

        setTimeout ()->
          app.close().then done
        , 5000

        done()
