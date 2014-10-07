class App
  init: ->
    @scene = @createScene()
    @initVfx()
    @myoManager = new MyoManager();
    @recorder = new MyoRecorder();
    @recorder.setup(myo_manager: @myoManager)
    @target_system = new TargetSystem(myo_recorder: @recorder)
    @visualizer = new MyoVisualizer(myo_recorder: @recorder, scene: @scene)
    @clock = new THREE.Clock()
    @controls = new THREE.TrackballControls( @camera, @renderer.domElement )

    $(window).on('keydown', @_keyDown).mousemove(@_mouseMove)#.on('resize', @_resize)

  update: ->
    return if @paused
    @controls.update( @clock.getDelta() );

  draw: ->
    @renderer.render(@scene, @camera)

  initVfx: ->
    # @camera = new THREE.OrthographicCamera(-1200, 1000, -1100, 1200, 10, 10000)
    @camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 1, 10000)
    @camera.position.z = 500
    
    # @renderer = new THREE.CanvasRenderer()
    @renderer = new THREE.WebGLRenderer({preserveDrawingBuffer: true}) # preserveDrawingBuffer: true allows for image exports, but has some performance implications

    @renderer.setSize(window.innerWidth, window.innerHeight)
    jQuery('body').append(this.renderer.domElement)

  createScene: ->
    scene = new THREE.Scene()
    return scene

  _resize: ->
    console.log 'TODO; _resize'

  _keyDown: (e) =>
    console.log 'keycode: ' + e.keyCode
    if(e.keyCode == 32) # space
      @recorder.record()

    if(e.keyCode == 78) # 'n'
      @target_system.newTarget()

    if(e.keyCode == 188) # ',' / '<'
      @target_system.prevTarget()

    if(e.keyCode == 78) # '.' / '>'
      @target_system.nextTarget()

jQuery(document).ready ->
  window.drawFrame = ->
    requestAnimationFrame(drawFrame)
    app.update()
    app.draw()

  window.app = new App()
  window.app.init()
  window.drawFrame()
  console.log('page loaded ok') 