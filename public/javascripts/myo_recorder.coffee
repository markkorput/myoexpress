@MyoRecorder = Backbone.Collection.extend
  model: MyoRecord

  setup: (_opts) ->
    @opts = _opts
    @myo_manager = @opts.myo_manager

  record: ->
    data = @myo_manager.getLastMyoData()

    if(data != {} && (@length < 1 || data.orientation != @last().get('orientation')))
      @add(@myo_manager.getLastMyoData())
