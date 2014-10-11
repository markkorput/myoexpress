class @MyoManager
  constructor: (_opts) ->
    @options = _opts
    @init()

  init: ->
    if typeof(io) != 'undefined'
      @socket = io.connect 'http://localhost'

    if @socket    
      @socket.on 'myo-orientation', (data) =>
        # console.log 'myo-orientation' 
        # console.log data
        @onOrientation data

  onOrientation: (data) ->
    @lastMyoData = data

  getLastMyoData: ->
    @lastMyoData || {}

  enableDummyData: (_enable) ->
    if _enable == true || _enable == undefined
      @scheduledDummyData = setTimeout(@dummyEmit, 500)
    else
      clearTimeout(@scheduledDummyData)

  dummyEmit: =>
    # console.log('Emitting dummy data...')
    @onOrientation
      orientation:
        x: Math.random()
        y: Math.random()
        z: Math.random()
    @enableDummyData()