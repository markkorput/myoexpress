WebSocket = require('ws')
socket = new WebSocket('ws://localhost:7204/myo/1')

#socket.on 'message', (message) ->
#  json = JSON.parse(message)
#    
#  if (json[0] != "event")
#    return console.log(message)
#
#  data = json[1]
#
#  if (data.type == "connected")
#    @myoID = data.myo
#
#  if (data.type != "orientation")
#    console.log(data)
#
#  # if (data.type == "pose")
#
# func = (obj, msg) ->
#   obj.on msg, (data) ->
#     console.log msg;
#     console.log data;
# 
# func(socket, 'connect');
# func(socket, 'message');
# func(socket, 'orientation');
# func(socket, 'connect_error');
# func(socket, 'connect_timeout');
# func(socket, 'error');
# func(socket, 'disconnect');

module.exports = socket;