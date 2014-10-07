class MyoManager
  constructor: (_opts) ->
    @options = _opts
    @init()

  init: ->
    @socket = io.connect 'http://localhost'

    sock.on 'news', (data) ->
      console.log(data)

      socket.on 'myo-orientation', (data) ->
        console.log 'myo-orientation' 
        console.log 'data'
        socket.emit 'thanks', giveme: 'more'
