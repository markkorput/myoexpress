class @MyoVisualizer
  constructor: (_opts) ->
    @options = _opts
    @scene = @options.scene
    @myo_recorder = @options.myo_recorder
    @meshes = []


    @myo_recorder.on 'add', (myo_record) =>
      orientation = myo_record.get('orientation')
      return if !orientation

      geometry = new THREE.SphereGeometry(50, 10, 10)
      material = new THREE.LineBasicMaterial()

      mesh = new THREE.Mesh(geometry, material)      
      mesh.position.set(orientation.x, orientation.y, orientation.z)
      mesh.position.multiply(new THREE.Vector3(500, 500, 500))

      @meshes << mesh
      @scene.add mesh



