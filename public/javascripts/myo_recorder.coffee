@MyoRecorder = Backbone.Collection.extend
  model: MyoRecord

  setup: (_opts) ->
    @opts = _opts
    @myo_manager = @opts.myo_manager

  record: ->
    data = @myo_manager.getLastMyoData()

    if(data != {} && (@length < 1 || data.orientation != @last().get('orientation')))
      @add(@myo_manager.getLastMyoData())

  autoRecDelay: -> @autoRecordDelay || @opts.autoRecordDelay || 1

  delayPercentage: ->
    (@t || 0.0) / @autoRecDelay()

  update: (dt) ->
    @t = (@t || 0) + dt

    if(@t > @autoRecDelay())
      @record()
      @t = 0

