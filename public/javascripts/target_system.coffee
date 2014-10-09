TargetModel = Backbone.Model.extend
  initialize: ->
    #

TargetCollection = Backbone.Collection.extend
  model: TargetModel


@TargetSystem = Backbone.Model.extend
  initialize: (opts) ->
    @myo_recorder = @get 'myo_recorder'

    # setup collection and load first target and define first target
    @targets = new TargetCollection()    
    @newTarget()

    # monitor recorder collection; add target name to every new record
    @myo_recorder.on 'add', (myo_record) =>
      myo_record.set(target: @activeTarget().get('name'))

    # if enabled, switch to next target after every added record
    if @get('autoNextTarget')
      @myo_recorder.on 'add', (myo_record) =>
        # if enabled automatically create new targets until maxTargets count is reached
        # console.log @get('maxTargets')
        # console.log @targets.length
        if @get('maxTargets') && @targets.length < @get('maxTargets')
          # console.log 'new'
          @newTarget()
        else
          # console.log 'next'
          @nextTarget()


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