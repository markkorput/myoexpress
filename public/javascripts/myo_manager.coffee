class @MyoManager
  constructor: (_opts) ->
    @options = _opts
    @init()

  init: ->
    @socket = io.connect 'http://localhost'

    @socket.on 'myo-orientation', (data) =>
      @lastMyoData = data
    #   console.log 'myo-orientation' 
    #   console.log data

  getLastMyoData: ->
    @lastMyoData || {}