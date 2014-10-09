@MyoRecorder = Backbone.Collection.extend
  model: MyoRecord

  setup: (_opts) ->
    @opts = _opts
    @myo_manager = @opts.myo_manager

  record: ->
    data = @myo_manager.getLastMyoData()

    if(data != {} && (@length < 1 || data.orientation != @last().get('orientation')))
      @add(@myo_manager.getLastMyoData())

  autoRecDelay: -> @autoRecordDelay || @opts.autoRecordDelay || 1000

  autoRecDelayPos: ->
    return 1.0 if !@lastAutoRecord
    t = (new Date()).getTime()
    (t - @lastAutoRecord) / @autoRecDelay()

  update: ->
    t = (new Date()).getTime()
    if(@autoRecDelayPos() >= 1.0)
      @record()
      @lastAutoRecord = t