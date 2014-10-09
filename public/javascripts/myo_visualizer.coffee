@MyoVisualizer = Backbone.Model.extend
  initialize: ->
    @scene = @get 'scene'
    @myo_recorder = @get 'myo_recorder'
    @meshes = []
    @passiveColor = new THREE.Color( 0x0000aa)
    @activeColor = new THREE.Color( 0xffffff )

    @myo_recorder.on 'add', (myo_record) =>
      orientation = myo_record.get('orientation')
      return if !orientation

      geometry = new THREE.SphereGeometry(50, 10, 10)
      material = new THREE.LineBasicMaterial()

      material.color = @activeColor

      mesh = new THREE.Mesh(geometry, material)      
      mesh.position.set(orientation.x, orientation.y, orientation.z)
      mesh.position.multiply(new THREE.Vector3(500, 500, 500))

      # link each mesh to it's originating record, so we can look them up later
      mesh.myo_record = myo_record

      @meshes.push mesh
      @scene.add mesh

      myo_record.on 'remove', (model) =>
        # console.log model
        mesh = @_meshForRecord(model)
        @scene.remove mesh
        # console.log @meshes.length
        @meshes = _.without(@meshes, model)
        # console.log @meshes.length

    @on 'change:highlight', (obj, value, attr) =>
      _.each @meshes, (mesh) =>
        mesh.material.color = @passiveColor
        if _.contains(_.flatten([value]), mesh.myo_record.get('target'))
          mesh.material.color = @activeColor

  _meshForRecord: (record) ->
    _.find @meshes, (mesh) -> mesh.myo_record == record




