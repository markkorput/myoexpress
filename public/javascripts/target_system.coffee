TargetModel = Backbone.Model.extend
  initialize: ->
    #

TargetCollection = Backbone.Collection.extend
  model: TargetModel


@TargetSystem = Backbone.Model.extend
  initialize: (opts) ->
    @myo_recorder = @get 'myo_recorder'

    @targets = new TargetCollection()
    @newTarget()

    @myo_recorder.on 'add', (myo_record) =>
      myo_record.set(target: @activeTarget().get('name'))

  newTarget: ->
    # console.log 'Adding: '+ 'Target #'+(@targets.length+1)
    @targets.add(name: 'Target #'+(@targets.length+1))
    # console.log 'new index: '+(@targets.length-1)
    @set(activeTargetIndex: @targets.length-1)

  activeTarget: ->
    @targets.at(@get('activeTargetIndex'))

  prevTarget: ->
    @set(activeTargetIndex: Math.abs((@get('activeTargetIndex') - 1) % @targets.length))

  nextTarget: ->
    @set(activeTargetIndex: Math.abs((@get('activeTargetIndex') + 1) % @targets.length))