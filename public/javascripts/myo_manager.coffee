class @MyoManager
  constructor: (_opts) ->
    @options = _opts
    @init()

    # @dummyEmit()

  dummyEmit: =>
    # console.log('Emitting dummy data...')
    @onOrientation
      orientation:
        x: Math.random()
        y: Math.random()
        z: Math.random()

    setTimeout(@dummyEmit, 500);

  init: ->
    @socket = io.connect 'http://localhost'

    @socket.on 'myo-orientation', (data) =>
      # console.log 'myo-orientation' 
      # console.log data
      @onOrientation data

  onOrientation: (data) ->
    @lastMyoData = data

  getLastMyoData: ->
    @lastMyoData || {}