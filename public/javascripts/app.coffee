class App
  init: ->
    @scene = @createScene()
    @initVfx()

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

  update: ->
    return if @paused

  draw: ->
    @renderer.render(@scene, @camera)



drawFrame = ->
  requestAnimationFrame(drawFrame)
  app.update()
  app.draw()

window.app = new App()
window.app.init()
drawFrame()
console.log('ok')