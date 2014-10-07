class Targets
  constructor: (_opts) ->
    @options = _opts

  position: -> @_position ||= @options.position || new THREE.Vector3(0,0,0)
  dimensions: -> @_dimensions ||= @options.dimensions || new THREE.Vector2(10, 10)
  cols: -> @dimensions().x
  rows: -> @dimensions().y
  cell_size: -> @_cell_size ||= @options.cell_size || new THREE.Vector3(200, 200, 200)
  spacing: -> @_spacing ||= @options.spacing || @cell_size()
  geometry: -> @_geometry ||= @options.geometry || new THREE.CubeGeometry(@cell_size().x, @cell_size().y, @cell_size().z)
  # geometry: -> @_geometry ||= @options.geometry || new THREE.PlaneGeometry(@cell_size().x, @cell_size().y)
  materials: -> @options.materials || @_materials ||= [new THREE.MeshBasicMaterial({color: 0xffffff})]
  random_material: -> @materials()[Math.floor(Math.random() * @materials().length)]

  boxes: -> @_boxes ||= @generateBoxes()

  generateBoxes: ->
    boxes = []

    for y in [0..@rows()-1]
      for x in [0..@cols()-1]
        mesh = new THREE.Mesh(@geometry(), @random_material())
        mesh.position.copy(@position())
        mesh.position.add(new THREE.Vector3(x*@spacing().x, y*@spacing().y, 0))
        boxes.push(mesh)

    return boxes;

  addBoxesToScene: (scene) ->
    for box in @boxes()
      scene.add(box)

  getBoxXY: (x,y) ->
    @boxes()[@cols()*y+x]

  randomBox: -> @boxes()[Math.floor(Math.random() * @boxes().length)]

  reset: ->
    console.log "Grid resetting"
    for y in [0..@rows()-1]
      for x in [0..@cols()-1]
        box = @getBoxXY(x,y)
        box.rotation.x = 0
        box.rotation.y = 0
        box.rotation.z = 0
        box.position.copy(@position())
        box.position.add(new THREE.Vector3(x*@spacing().x, y*@spacing().y, 0))


class App
  init: ->
    @scene = @createScene()
    @initVfx()
    @myoManager = new MyoManager();

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

    @targets = new Targets
      dimensions: new THREE.Vector2(26,10),
      position: new THREE.Vector3(-2500, -900, -1000),
      cell_size: new THREE.Vector3(200, 200, 10),
      materials: [new THREE.MeshBasicMaterial({color: 0xffbb00}), new THREE.MeshBasicMaterial({color: 0xcc9900}), new THREE.MeshBasicMaterial({color: 0xddaa00})]

    # targets.boxes()[3].material.color.setHex(0xff0f0f)
    @targets.addBoxesToScene(scene)

    return scene

  update: ->
    return if @paused

  draw: ->
    @renderer.render(@scene, @camera)


jQuery(document).ready ->
  window.drawFrame = ->
    requestAnimationFrame(drawFrame)
    app.update()
    app.draw()

  window.app = new App()
  window.app.init()
  window.drawFrame()
  console.log('page loaded ok') 