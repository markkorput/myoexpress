@MyoRecorder = Backbone.Collection.extend
  model: MyoRecord

  setup: (_opts) ->
    @opts = _opts
    @myo_manager = @opts.myo_manager

  record: ->
    @add(@myo_manager.getLastMyoData())
