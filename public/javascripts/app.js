// Generated by CoffeeScript 1.6.3
(function() {
  var App,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  App = (function() {
    function App() {
      this._keyDown = __bind(this._keyDown, this);
    }

    App.prototype.init = function() {
      var _this = this;
      this.scene = this.createScene();
      this.initVfx();
      this.myoManager = new MyoManager();
      this.recorder = new MyoRecorder();
      this.recorder.setup({
        myo_manager: this.myoManager,
        autoRecordDelay: 2
      });
      this.target_system = new TargetSystem({
        myo_recorder: this.recorder,
        autoNextTarget: true,
        maxTargets: 10
      });
      this.visualizer = new MyoVisualizer({
        myo_recorder: this.recorder,
        scene: this.scene,
        myo_manager: this.myoManager,
        ghost: true
      });
      this.target_system.on('change:activeTargetIndex', function(obj, value, attr) {
        _this.visualizer.set({
          highlight: _this.target_system.activeTarget().get('name')
        });
        return _this.gui_values.currentTarget = value + 1;
      });
      this.clock = new THREE.Clock();
      this.controls = new THREE.TrackballControls(this.camera, this.renderer.domElement);
      this.initGui();
      return $(window).on('keydown', this._keyDown).mousemove(this._mouseMove);
    };

    App.prototype.update = function() {
      var dt;
      dt = this.clock.getDelta();
      this.controls.update(dt);
      if (this.gui_values.paused) {
        return;
      }
      this.recorder.update(dt);
      return this.gui_values.timer = this.recorder.delayPercentage();
    };

    App.prototype.draw = function() {
      return this.renderer.render(this.scene, this.camera);
    };

    App.prototype.initVfx = function() {
      this.camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 1, 10000);
      this.camera.position.z = 500;
      this.renderer = new THREE.WebGLRenderer({
        preserveDrawingBuffer: true
      });
      this.renderer.setSize(window.innerWidth, window.innerHeight);
      return jQuery('body').append(this.renderer.domElement);
    };

    App.prototype.createScene = function() {
      var scene;
      scene = new THREE.Scene();
      return scene;
    };

    App.prototype._resize = function() {
      return console.log('TODO; _resize');
    };

    App.prototype._keyDown = function(e) {
      var r, _results;
      console.log('keycode: ' + e.keyCode);
      if (e.keyCode === 82) {
        this.recorder.record();
      }
      if (e.keyCode === 32) {
        this.gui_values.paused = !this.gui_values.paused;
      }
      if (e.keyCode === 78) {
        this.target_system.newTarget();
      }
      if (e.keyCode === 188) {
        this.target_system.prevTarget();
      }
      if (e.keyCode === 190) {
        this.target_system.nextTarget();
      }
      if (e.keyCode === 67) {
        _results = [];
        while (r = this.recorder.first()) {
          _results.push(this.recorder.remove(r));
        }
        return _results;
      }
    };

    App.prototype.initGui = function() {
      var folder, item,
        _this = this;
      this.gui = new dat.GUI();
      this.gui_values = new function() {
        this.timer = 0;
        this.delay = 2;
        this.paused = false;
        this.maxTargets = 10;
        this.currentTarget = 1;
        this.ghost = true;
        return this.fakeData = false;
      };
      folder = this.gui.addFolder('Elements');
      item = folder.add(this.gui_values, 'timer', 0, 1);
      item.listen();
      item = folder.add(this.gui_values, 'delay', 0, 5);
      item.onChange(function(val) {
        return _this.recorder.autoRecordDelay = val;
      });
      item = folder.add(this.gui_values, 'paused');
      item.listen();
      item = folder.add(this.gui_values, 'maxTargets', 1, 30);
      item.onChange(function(val) {
        return _this.target_system.set('maxTargets');
      });
      item = folder.add(this.gui_values, 'currentTarget', 1, 10);
      item.listen();
      item = folder.add(this.gui_values, 'ghost');
      item.onChange(function(val) {
        return _this.visualizer.set({
          ghost: val
        });
      });
      item = folder.add(this.gui_values, 'fakeData');
      item.onChange(function(val) {
        return _this.myoManager.enableDummyData(val);
      });
      return folder.open();
    };

    return App;

  })();

  jQuery(document).ready(function() {
    window.drawFrame = function() {
      requestAnimationFrame(drawFrame);
      app.update();
      return app.draw();
    };
    window.app = new App();
    window.app.init();
    window.drawFrame();
    return console.log('page loaded ok');
  });

}).call(this);
