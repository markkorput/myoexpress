TargetModel = Backbone.Model.extend
  initialize: ->
    #

TargetCollection = Backbone.Collection.extend
  model: TargetModel


class @TargetSystem
  constructor: (opts) ->
    @options = opts
    @myo_recorder = @options.myo_recorder

    @targets = new TargetCollection()
    @newTarget()

    @myo_recorder.on 'add', (myo_record) =>
      myo_record.set(target: @activeTarget().get('name'))

  newTarget: ->
    @targets.add(name: 'Target #'+(@targets.length+1))
    @activeTargetIndex = @targets.length-1

  activeTarget: ->
    @targets.at(@activeTargetIndex)

  prevTarget: ->
    @activeTargetIndex -= 1
    @activeTargetIndex = @targets.length-1 if @activeTargetIndex < 0

  nextTarget: ->
    @activeTargetIndex += 1
    @activeTargetIndex = 0 if @activeTargetIndex >= @target.length
