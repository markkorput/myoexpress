class App
  init: ->
    @scene = @createScene()
    @initVfx()

    @myoManager = new MyoManager();
    @recorder = new MyoRecorder();
    @recorder.setup(myo_manager: @myoManager, autoRecordDelay: 1000)
    @target_system = new TargetSystem(myo_recorder: @recorder, autoNextTarget: true, maxTargets: 4)
    @visualizer = new MyoVisualizer(myo_recorder: @recorder, scene: @scene)
    @target_system.on 'change:activeTargetIndex', (obj, value, attr) =>
      @visualizer.set(highlight: @target_system.activeTarget().get('name'))

    @clock = new THREE.Clock()
    @controls = new THREE.TrackballControls( @camera, @renderer.domElement )
    @initGui()    
    $(window).on('keydown', @_keyDown).mousemove(@_mouseMove)#.on('resize', @_resize)

  update: ->
    @controls.update( @clock.getDelta() );

    return if @gui_values.paused
    
    @recorder.update()
    @gui_values.timer = @recorder.autoRecDelayPos()

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

    if(e.keyCode == 82) # 'r'
      @recorder.record()

    if(e.keyCode == 32) # space
      @gui_values.paused = (!@gui_values.paused)      

    if(e.keyCode == 78) # 'n'
      @target_system.newTarget()

    if(e.keyCode == 188) # ',' / '<'
      @target_system.prevTarget()

    if(e.keyCode == 190) # '.' / '>'
      @target_system.nextTarget()

    if(e.keyCode == 67) # 'c'
      while r = @recorder.first()
        @recorder.remove(r)


  initGui: ->
    @gui = new dat.GUI() # ({autoPlace:true});

    @gui_values = new ->
      @timer = 0
      @delay = 1000
      @paused = false
      @maxTargets = 4

    folder = @gui.addFolder 'Elements'
    item = folder.add(@gui_values, 'timer', 0, 1)
    item.listen()
    item = folder.add(@gui_values, 'delay', 0, 5000)
    item.onChange (val) => @recorder.autoRecordDelay = val
    item = folder.add(@gui_values, 'paused')
    item.listen()
    item = folder.add(@gui_values, 'maxTargets', 1, 30)
    item.onChange (val) => @target_system.set('maxTargets')
    folder.open()


jQuery(document).ready ->
  window.drawFrame = ->
    requestAnimationFrame(drawFrame)
    app.update()
    app.draw()

  window.app = new App()
  window.app.init()
  window.drawFrame()
  console.log('page loaded ok') 