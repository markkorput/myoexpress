// Generated by CoffeeScript 1.6.3
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  this.MyoManager = (function() {
    function MyoManager(_opts) {
      this.dummyEmit = __bind(this.dummyEmit, this);
      this.options = _opts;
      this.init();
    }

    MyoManager.prototype.init = function() {
      var _this = this;
      if (typeof io !== 'undefined') {
        this.socket = io.connect('http://localhost');
      }
      if (this.socket) {
        return this.socket.on('myo-orientation', function(data) {
          return _this.onOrientation(data);
        });
      }
    };

    MyoManager.prototype.onOrientation = function(data) {
      return this.lastMyoData = data;
    };

    MyoManager.prototype.getLastMyoData = function() {
      return this.lastMyoData || {};
    };

    MyoManager.prototype.enableDummyData = function(_enable) {
      if (_enable === true || _enable === void 0) {
        return this.scheduledDummyData = setTimeout(this.dummyEmit, 500);
      } else {
        return clearTimeout(this.scheduledDummyData);
      }
    };

    MyoManager.prototype.dummyEmit = function() {
      this.onOrientation({
        orientation: {
          x: Math.random(),
          y: Math.random(),
          z: Math.random()
        }
      });
      return this.enableDummyData();
    };

    return MyoManager;

  })();

}).call(this);
