var ConvexTextRing, WorldUVGenerator, debug, qtE, qyt,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

ConvexTextRing = function(callback) {
  var combine, create, createText, vLast, _ref;
  _global.rotate = true;
  addRotateModelHandlers();
  _ref = [0, Math.PI], controls.minPolarAngle = _ref[0], controls.maxPolarAngle = _ref[1];
  controls.maxDistance = 38;
  camera.position.z = 100;
  camera.position.y = 80;
  $("#ajax-loading").show();
  combine = new THREE.Object3D;
  combine.userData.model = true;
  create = (function(_this) {
    return function(opts, regenRing) {
      var a, amount, b, e, extend, fontHeight, fontThickness, geom, maxTextCount, n, o, options, p, r, ring1, ring2, s, t, textRadius, v;
      if (regenRing == null) {
        regenRing = true;
      }
      options = {
        text: modelParams.str == null ? "MYOMYO" : modelParams.str,
        font: config.p2.defaultFont,
        sideSmooth: 0.5,
        bottomSmooth: config.p2.sideSmooth,
        thickness: 2,
        ringSize: 18,
        height: 2.5,
        materialName: "Silver",
        fontHeight: 4,
        distance: 4
      };
      textRadius = 10;
      fontThickness = 0;
      fontHeight = options.fontHeight;
      maxTextCount = 0;
      extend = function(object, properties) {
        var key, val;
        for (key in properties) {
          val = properties[key];
          object[key] = val;
        }
        return object;
      };
      options = extend(options, opts);
      options.frontContourBevelThickness = options.sideSmooth * (options.height - 0.2);
      options.frontContourBevelSize = options.bottomSmooth * (options.thickness - 0.2);
      options.backContourBevelThickness = 0;
      options.backContourBevelSize = 0;
      s = 0.1;
      o = Math.max(options.frontContourBevelThickness, 0.1);
      r = 0.1;
      amount = Math.max(0.1, options.height - o - r);
      p = options.ringSize / 2 + s;
      n = options.ringSize / 2 + options.thickness - options.frontContourBevelSize;
      if (p > n) {
        n = p + 1;
      }
      options.amount = amount;
      t = new THREE.Shape;
      t.moveTo(n, 0);
      t.absarc(0, 0, n, 0, Math.PI * 2, false);
      e = new THREE.Path;
      e.moveTo(p, 0);
      e.absarc(0, 0, p, 0, Math.PI * 2, true);
      t.holes.push(e);
      a = new qyt(t, options);
      v = new THREE.Mesh(a, silverMaterial.clone());
      v.userData.meshDown = true;
      v.rotation.x = Math.PI / 2;
      v.position.y = -options.fontHeight / 2;
      combine.add(v);
      if (regenRing) {
        if (options.bottomSmooth !== 1.0) {
          geom = new THREE.RingGeometry(p - 0.0, n + 0.1, 32, 32, 0, Math.PI * 2);
          ring1 = new THREE.Mesh(geom, silverMaterial.clone());
          ring1.userData.ringUp = true;
          ring1.rotation.x = -Math.PI / 2;
          ring1.position.y = options.fontHeight / 2 + options.height - 0.07;
          ring2 = ring1.clone();
          ring2.userData.ringDown = true;
          ring2.rotation.x = Math.PI / 2;
          ring2.position.y = -options.fontHeight / 2 - options.height + 0.07;
          combine.add(ring1);
          combine.add(ring2);
        }
      }
      b = new THREE.Mesh(a, silverMaterial.clone());
      b.userData.meshUp = true;
      b.rotation.x = -Math.PI / 2;
      b.position.y = options.fontHeight / 2;
      combine.add(b);
      return changeMaterialNew(combine, modelParams.material);
    };
  })(this);
  createText = (function(_this) {
    return function(opts) {
      var amount, extend, fontHeight, fontThickness, i, k, m, maxTextCount, n, o, options, p, q, qrX, qtb, r, s, t, textRadius;
      options = {
        text: "MYOMYO",
        font: config.p2.defaultFont,
        sideSmooth: 0.5,
        bottomSmooth: config.p2.sideSmooth,
        thickness: 3,
        ringSize: 18,
        height: 2.5,
        materialName: "Silver",
        fontHeight: 4,
        distance: 1000
      };
      textRadius = 0;
      fontThickness = 0;
      fontHeight = options.fontHeight;
      maxTextCount = 0;
      extend = function(object, properties) {
        var key, val;
        for (key in properties) {
          val = properties[key];
          object[key] = val;
        }
        return object;
      };
      options = extend(options, opts);
      options.frontContourBevelThickness = options.sideSmooth * (options.height - 0.2);
      options.frontContourBevelSize = options.bottomSmooth * (options.thickness - 0.2);
      options.backContourBevelThickness = 0;
      options.backContourBevelSize = 0;
      s = 0.1;
      o = Math.max(options.frontContourBevelThickness, 0.1);
      r = 0.1;
      amount = Math.max(0.1, options.height - o - r);
      p = options.ringSize / 2 + s;
      n = options.ringSize / 2 + options.thickness - options.frontContourBevelSize;
      if (p > n) {
        n = p + 1;
      }
      options.amount = amount;
      m = (p + p + options.thickness - 0.2 - options.fontHeight * 0.09) / 2;
      options = {
        font: opts.font,
        text: opts.text,
        fontHeight: options.fontHeight,
        size: 2,
        fontThickness: options.fontThickness
      };
      t = new THREE.Shape();
      t.moveTo(m, 0);
      t.absarc(0, 0, m, 2 * Math.PI, 0, true);
      q = t.getSpacedPoints(100);
      qtb = function(b, a) {
        return new THREE.Vector3(b.x, 0, b.y);
      };
      qrX = function(c, a) {
        var b, d, e;
        e = [];
        for (b in c) {
          d = qtb(c[b], a);
          e.push(d);
        }
        return e;
      };
      k = new THREE.SplineCurve3(qrX(q));
      options.qup = k;
      i = new qtE(_this.qab, options);
      i.create();
      i.text.position.y = 0;
      i.text.position.x = 0;
      i.text.position.z = 0;
      i.text.userData.text = true;
      combine.add(i.text);
      return changeMaterialNew(combine, modelParams.material);
    };
  })(this);
  modelParams.height = config.p2.ringHeight;
  modelParams.heightv = modelParams.height;
  modelParams.thickness = config.p2.ringThickness;
  modelParams.fontThickness = modelParams.thickness;
  modelParams.bottomSmooth = config.p2.sideSmooth;
  modelParams.font = config.p2.defaultFont;
  modelParams.fontHeight = config.p2.fontHeight;
  modelParams.changeHeight = function(v) {
    var m, mesh, obj, ring, _i, _j, _k, _l, _len, _len1, _len2, _len3, _len4, _m, _ref1, _ref2, _ref3, _ref4, _ref5;
    _ref1 = scene.children;
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      obj = _ref1[_i];
      if (!((obj != null) && obj.userData.model === true)) {
        continue;
      }
      m = null;
      _ref2 = obj.children;
      for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
        mesh = _ref2[_j];
        if (!((mesh != null) && mesh.userData.meshDown === true)) {
          continue;
        }
        mesh.scale.z = v * 0.4;
        m = mesh;
      }
      _ref3 = obj.children;
      for (_k = 0, _len2 = _ref3.length; _k < _len2; _k++) {
        ring = _ref3[_k];
        if ((ring != null) && ring.userData.ringDown === true) {
          ring.position.y = -modelParams.fontHeight / 2 - modelParams.height * v * 0.39;
        }
      }
      m = null;
      _ref4 = obj.children;
      for (_l = 0, _len3 = _ref4.length; _l < _len3; _l++) {
        mesh = _ref4[_l];
        if (!((mesh != null) && mesh.userData.meshUp === true)) {
          continue;
        }
        mesh.scale.z = v * 0.4;
        m = mesh;
      }
      _ref5 = obj.children;
      for (_m = 0, _len4 = _ref5.length; _m < _len4; _m++) {
        ring = _ref5[_m];
        if ((ring != null) && ring.userData.ringUp === true) {
          ring.position.y = modelParams.fontHeight / 2 + modelParams.height * v * 0.39;
        }
      }
    }
    modelParams.heightv = v;
    return renderf();
  };
  vLast = 0;
  modelParams.changeThickness = (function(_this) {
    return function(v) {
      var x, _i, _len, _ref1;
      v = parseFloat(v);
      _ref1 = scene.children.last().children.slice(0);
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        x = _ref1[_i];
        scene.children.last().remove(x);
      }
      modelParams.thickness = v;
      modelParams.fontThickness = v;
      create(modelParams);
      createText(modelParams);
      modelParams.changeHeight(modelParams.heightv);
      return renderf();
    };
  })(this);
  modelParams.changeSideSmooth = (function(_this) {
    return function(v) {
      var x, _i, _len, _ref1;
      _ref1 = scene.children.last().children.slice(0);
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        x = _ref1[_i];
        if (x.userData.text == null) {
          scene.children.last().remove(x);
        }
      }
      modelParams.bottomSmooth = v;
      create(modelParams);
      modelParams.changeHeight(modelParams.heightv);
      return renderf();
    };
  })(this);
  modelParams.changeFontHeight = (function(_this) {
    return function(v) {
      var x, _i, _j, _k, _l, _len, _len1, _len2, _len3, _len4, _m, _ref1, _ref2, _ref3, _ref4, _ref5;
      _ref1 = scene.children.last().children.slice(0);
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        x = _ref1[_i];
        if (x.userData.text === true) {
          scene.children.last().remove(x);
        }
      }
      _ref2 = scene.children.last().children.slice(0);
      for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
        x = _ref2[_j];
        if (x.userData.meshDown === true) {
          x.position.y = -v / 2;
        }
      }
      _ref3 = scene.children.last().children.slice(0);
      for (_k = 0, _len2 = _ref3.length; _k < _len2; _k++) {
        x = _ref3[_k];
        if (x.userData.meshUp === true) {
          x.position.y = v / 2;
        }
      }
      _ref4 = scene.children.last().children.slice(0);
      for (_l = 0, _len3 = _ref4.length; _l < _len3; _l++) {
        x = _ref4[_l];
        if (x.userData.ringDown === true) {
          x.position.y = -v / 2 - modelParams.heightv;
        }
      }
      _ref5 = scene.children.last().children.slice(0);
      for (_m = 0, _len4 = _ref5.length; _m < _len4; _m++) {
        x = _ref5[_m];
        if (x.userData.ringUp === true) {
          x.position.y = v / 2 + modelParams.heightv;
        }
      }
      modelParams.fontHeight = v;
      createText(modelParams);
      return renderf();
    };
  })(this);
  modelParams.changeFont = (function(_this) {
    return function(currentStr, font) {
      var f;
      f = function() {
        var a, b, c, maxTextCount, _i;
        maxTextCount = Math.PI * config.p2.size / 4;
        a = parseInt(maxTextCount / currentStr.length);
        if (a && currentStr.length < 6) {
          c = "";
          for (b = _i = 0; 0 <= a ? _i <= a : _i >= a; b = 0 <= a ? ++_i : --_i) {
            c += currentStr;
            if (c.length > 5) {
              break;
            }
          }
          return c;
        }
        return currentStr.substr(0, maxTextCount);
      };
      currentStr = f();
      modelParams.font = font;
      return modelParams.changeText(currentStr, font);
    };
  })(this);
  modelParams.changeText = function(str) {
    var x, _i, _len, _ref1;
    _ref1 = scene.children.last().children.slice(0);
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      x = _ref1[_i];
      if (x.userData.text === true) {
        scene.children.last().remove(x);
      }
    }
    modelParams.text = str;
    createText(modelParams);
    return renderf();
  };
  modelParams.changeSize = function(v) {
    var ring, _i, _len, _ref1;
    _ref1 = scene.children;
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      ring = _ref1[_i];
      if ((ring != null) && ring.userData.model === true) {
        ring.scale.x = ring.scale.y = ring.scale.z = v * 0.055;
      }
    }
    return renderf();
  };
  modelParams.functionsTable["p-height"] = modelParams.changeHeight;
  modelParams.functionsTable["p-thickness"] = modelParams.changeThickness;
  modelParams.functionsTable["p-text-height"] = modelParams.changeFontHeight;
  modelParams.functionsTable["p-side-smooth"] = modelParams.changeSideSmooth;
  modelParams.functionsTable["p-selected-font"] = modelParams.changeFont;
  modelParams.functionsTable["p-panel-text"] = modelParams.changeText;
  modelParams.functionsTable["p-size"] = modelParams.changeSize;
  if (loadedModels.mring === null) {
    create(modelParams);
    modelParams.text = "MYOMYO";
    createText(modelParams);
    loadedModels.mring = combine.clone();
    combine.scale.x = combine.scale.y = combine.scale.z = config.p3.size * 0.055;
    scene.add(combine);
  } else {
    combine = loadedModels.mring.clone();
    changeMaterialNew(combine, modelParams.material);
    combine.scale.x = combine.scale.y = combine.scale.z = config.p3.size * 0.055;
    scene.add(combine);
  }
  return $("#ajax-loading").hide();
};

qtE = (function(_super) {
  __extends(qtE, _super);

  function qtE(b, a) {
    var qrU;
    qtE.__super__.constructor.apply(this, arguments);
    this.qab = b;
    this.text = new THREE.Object3D();
    this.qwh = [];
    if (a.qup === undefined) {
      return;
    }
    this.qiu();
    qrU = function(c, a) {
      for (b in a) {
        if (a[b] !== undefined) {
          c[b] = a[b];
        }
      }
      return c;
    };
    qrU(this.options, a);
    this.qqe = true;
    return;
  }

  qtE.prototype.qpo = function(d) {
    var b, c, e, qiW;
    c = new THREE.TextGeometry(d, this.options);
    c.computeBoundingBox();
    c.computeVertexNormals();
    THREE.GeometryUtils.center(c);
    qiW = function(geometry, v3, c) {
      var e, f, g, h, i, t, vert, vertList, _results;
      vertList = geometry.vertices;
      c = Math.abs(0 - v3.z);
      g = 0 - v3.z;
      _results = [];
      for (i in vertList) {
        t = vertList[i];
        vert = vertList[i];
        f = vert.x / c;
        h = c * Math.sin(f);
        g = c * Math.cos(f);
        e = (new THREE.Vector2(h, g)).normalize();
        vert.x = h + v3.x + e.x * vert.z;
        _results.push(vert.z = g + v3.z + e.y * vert.z);
      }
      return _results;
    };
    b = silverMaterial.clone();
    e = new THREE.Mesh(c, b);
    return e;
  };

  qtE.prototype.qeg = function(a) {
    var b;
    for (b in a) {
      this.options[b] = a[b];
    }
  };

  qtE.prototype.qiu = function() {
    this.options = {
      isSpaceFixed: false,
      text: "FFFFFF",
      qrK: 30,
      position: 0,
      size: 0,
      fontHeight: 2,
      fontThickness: 1,
      height: 0.4,
      curveSegments: 4,
      quj: 15.8,
      font: "helvetiker",
      weight: "normal",
      style: "normal",
      bevelThickness: 0.01,
      bevelSize: 0.1,
      bevelSegments: 1,
      bevelEnabled: true,
      qrn: 1,
      extrudeMaterial: 0
    };
  };

  qtE.prototype.update = function(a) {
    var qrU;
    if (a.text !== this.options.text || a.font !== this.options.font) {
      this.qqe = true;
    } else {
      this.qqe = false;
    }
    qrU = function(c, a) {
      var b;
      for (b in a) {
        if (a[b] !== undefined) {
          c[b] = a[b];
        }
      }
      return c;
    };
    qrU(this.options, a);
    this.create();
  };

  qtE.prototype.qau = function() {
    var a, b;
    a = this.qab;
    for (b in this.qwh) {
      a.qaq(this.qwh[b]);
    }
    this.qwh.length = 0;
    this.create();
  };

  qtE.prototype.create = function() {
    var a, b, e, f, g, h, i, j, k, l, m, n, p, q, r, s, t, _results;
    j = this.qab;
    q = void 0;
    q = this.options.text.length + 0.9;
    if (this.options.text.length > 6) {
      q = this.options.text.length + 1.2;
    }
    if (this.options.text.length === 8) {
      q = this.options.text.length + 1.3;
    }
    if (this.options.text.length === 9) {
      q = this.options.text.length + 1.6;
    }
    if (this.options.text.length === 10) {
      q = this.options.text.length + 1.7;
    }
    if (this.options.text.length === 11) {
      q = this.options.text.length + 1.8;
    }
    if (this.options.text.length === 12) {
      q = this.options.text.length + 1.9;
    }
    n = void 0;
    f = [];
    n = 0;
    while (n < q) {
      h = this.options.position + n / q;
      if (h > 1) {
        h -= 1;
      }
      f.push(this.options.qup.getPointAt(h));
      n++;
    }
    if (this.qqe) {
      for (a in this.qwh) {
        this.text.remove(this.qwh[a]);
      }
      this.qwh.length = 0;
    }
    k = 0;
    _results = [];
    for (p in this.options.text) {
      if (this.options.text[p] !== " ") {
        t = void 0;
        if (this.qqe) {
          t = this.qpo(this.options.text[p]);
          this.qwh.push(t);
          this.text.add(t);
          t.qpm = true;
        } else {
          t = this.qwh[k];
          k++;
        }
        t.position = f[p];
        r = new THREE.Vector3(0, 0, 1);
        h = this.options.position + p / q;
        if (h > 1) {
          h -= 1;
        }
        i = this.options.qup.getTangentAt(h);
        s = i;
        m = s.applyAxisAngle(new THREE.Vector3(0, 1, 0), -Math.PI / 2);
        l = r.angleTo(m);
        t.setRotationFromQuaternion(new THREE.Quaternion());
        t.rotateY(l);
        if (m.x < 0) {
          t.rotateY((Math.PI - l) * 2);
        }
        g = t.geometry.boundingBox;
        b = this.options.fontHeight / (g.max.y - g.min.y);
        e = this.options.fontThickness / (g.max.z - g.min.z);
        _results.push(t.scale.set(b, b, e));
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  return qtE;

})(THREE.Mesh);

qyt = (function(_super) {
  __extends(qyt, _super);

  function qyt(b, a) {
    qyt.__super__.constructor.apply(this, arguments);
    this.__v1 = new THREE.Vector2;
    this.__v2 = new THREE.Vector2;
    this.__v3 = new THREE.Vector2;
    this.__v4 = new THREE.Vector2;
    this.__v5 = new THREE.Vector2;
    this.__v6 = new THREE.Vector2;
    this.qiu(a);
    this.addShape(b);
    this.computeFaceNormals();
    this.computeVertexNormals();
  }

  return qyt;

})(THREE.Geometry);

qyt.prototype.addShapeList = function(b, c) {
  var a, d, e;
  a = b.length;
  d = 0;
  while (d < a) {
    e = b[d];
    this.addShape(e, c);
    d++;
  }
};

qyt.prototype.qiu = function(a) {
  var b, c;
  c = {};
  c.amount = 1.5;
  c.curveSegments = 30;
  c.bevelEnabled = true;
  c.bevelSegments = 5;
  c.steps = 1;
  c.holeBevelSize = 0.1;
  c.bevelSize = 0.1;
  c.bevelThickness = 0.1;
  c.frontContourBevelSize = 0.1;
  c.frontContourBevelThickness = 0.1;
  c.backContourBevelSize = 0.1;
  c.backContourBevelThickness = 0.1;
  c.frontHoleBevelSize = 0.1;
  c.frontHoleBevelThickness = 0.1;
  c.backHoleBevelSize = 0.1;
  c.backHoleBevelThickness = 0.1;
  c.innerRadius = 14;
  c.outerRadius = 15;
  c.height = 2;
  c.thickness = 1;
  for (b in a) {
    c[b] = a[b];
  }
  this.options = c;
};

qyt.prototype.addShape = function(aF) {
  var A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z, a, aA, aB, aC, aD, aE, aG, aH, aI, aJ, aK, aL, aa, ab, ac, ad, ae, af, ag, ah, ai, aj, ak, al, am, an, ao, ap, aq, ar, at, au, av, aw, ax, ay, az, c, d, e, f, g, l, m, n, o, p, q, r, u;
  aD = function(i, h, b) {
    if (!h) {
      console.log("die");
    }
    return h.clone().multiplyScalar(b).add(i);
  };
  aE = function(i, h, b) {
    return d(i, h, b);
  };
  f = function(j, i, h) {
    var aM, b, k, s, t, v;
    t = Math.atan2(i.y - j.y, i.x - j.x);
    s = Math.atan2(h.y - j.y, h.x - j.x);
    if (t > s) {
      s += Math.PI * 2;
    }
    k = (t + s) / 2;
    aM = -Math.cos(k);
    v = -Math.sin(k);
    b = new THREE.Vector2(aM, v);
    return b;
  };
  d = (function(_this) {
    return function(aN, aM, t) {
      var aO, aP, aQ, aR, aS, aT, aU, aV, h, i, j, k;
      aS = _this.__v1;
      aP = _this.__v2;
      aR = _this.__v3;
      aO = _this.__v4;
      j = _this.__v5;
      i = _this.__v6;
      aU = void 0;
      aT = void 0;
      k = void 0;
      aQ = void 0;
      aV = void 0;
      h = void 0;
      aS.set(aN.x - aM.x, aN.y - aM.y);
      aP.set(aN.x - t.x, aN.y - t.y);
      aU = aS.normalize();
      aT = aP.normalize();
      aR.set(-aU.y, aU.x);
      aO.set(aT.y, -aT.x);
      j.copy(aN).add(aR);
      i.copy(aN).add(aO);
      if (j.equals(i)) {
        return aO.clone();
      }
      j.copy(aM).add(aR);
      i.copy(t).add(aO);
      k = aU.dot(aO);
      aQ = i.sub(j).dot(aO);
      if (k === 0) {
        console.log("Either infinite or no solutions!");
        if (aQ === 0) {
          console.log("Its finite solutions.");
        } else {
          console.log("Too bad, no solutions.");
        }
      }
      aV = aQ / k;
      if (aV < 0) {
        return f(aN, aM, t);
      }
      h = aU.multiplyScalar(aV).add(j);
      return h.sub(aN).clone();
    };
  })(this);
  ac = function() {
    var b, c, h, j;
    if (B) {
      j = 0;
      b = at * j;
      h = 0;
      while (h < F) {
        c = aK[h];
        p(c[2] + b, c[1] + b, c[0] + b, true);
        h++;
      }
      j = R + C * 2;
      b = at * j;
      h = 0;
      while (h < F) {
        c = aK[h];
        p(c[0] + b, c[1] + b, c[2] + b, false);
        h++;
      }
    } else {
      h = 0;
      while (h < F) {
        c = aK[h];
        p(c[2], c[1], c[0], true);
        h++;
      }
      h = 0;
      while (h < F) {
        c = aK[h];
        p(c[0] + at * R, c[1] + at * R, c[2] + at * R, false);
        h++;
      }
    }
  };
  aw = function() {
    var aG, b, i, j;
    i = 0;
    K(aB, i);
    i += aB.length;
    j = 0;
    b = aH.length;
    while (j < b) {
      aG = aH[j];
      K(aG, i);
      i += aG.length;
      j++;
    }
  };
  K = function(aO, h) {
    var V, aM, aN, aP, aQ, aR, aS, aT, i, t, v;
    aM = void 0;
    v = void 0;
    V = aO.length;
    while (--V >= 0) {
      aM = V;
      v = V - 1;
      if (v < 0) {
        v = aO.length - 1;
      }
      aT = 0;
      i = R + C * 2;
      aT = 0;
      while (aT < i) {
        aN = at * aT;
        t = at * (aT + 1);
        aS = h + aM + aN;
        aR = h + v + aN;
        aQ = h + v + t;
        aP = h + aM + t;
        o(aS, aR, aQ, aP, aO, aT, i, aM, v);
        aT++;
      }
    }
  };
  N = function(b, i, h) {
    av.vertices.push(new THREE.Vector3(b, i, h));
  };
  p = function(i, h, s, k) {
    var j;
    i += n;
    h += n;
    s += n;
    av.faces.push(new THREE.Face3(i, h, s, null, null, M));
    j = (k ? aC.generateBottomUV(av, aF, an, i, h, s) : aC.generateTopUV(av, aF, an, i, h, s));
    av.faceVertexUvs[0].push(j);
  };
  o = function(aN, aM, t, s, h, j, aO, v, k) {
    var i;
    aN += n;
    aM += n;
    t += n;
    s += n;
    av.faces.push(new THREE.Face3(aN, aM, s, null, null, l));
    av.faces.push(new THREE.Face3(aM, t, s, null, null, l));
    i = aC.generateSideWallUV(av, aF, h, an, aN, aM, t, s, j, aO, v, k);
    av.faceVertexUvs[0].push([i[0], i[1], i[3]]);
    av.faceVertexUvs[0].push([i[1], i[2], i[3]]);
  };
  an = this.options;
  ad = an.bevelThickness;
  aI = an.bevelSize;
  C = an.bevelSegments;
  a = an.frontContourBevelSize;
  ae = an.backContourBevelSize;
  I = an.frontHoleBevelSize;
  ai = an.backHoleBevelSize;
  af = an.frontContourBevelThickness;
  ao = an.backContourBevelThickness;
  U = an.frontHoleBevelThickness;
  aJ = an.backHoleBevelThickness;
  am = Math.max(I, ai);
  au = Math.max(a, ae);
  J = an.amount;
  this.qup = aF;
  B = an.bevelEnabled;
  ar = an.curveSegments;
  R = an.steps;
  u = an.extrudePath;
  al = void 0;
  q = false;
  M = an.qrn;
  l = an.extrudeMaterial;
  aC = (an.UVGenerator !== undefined ? an.UVGenerator : WorldUVGenerator);
  this.shapebb = aF.getBoundingBox();
  aA = this.shapebb;
  r = void 0;
  Y = void 0;
  ab = void 0;
  X = void 0;
  if (u) {
    al = u.qef(R);
    q = true;
    B = false;
    r = (an.frames !== undefined ? an.frames : new qom.qqx.FrenetFrames(u, R, false));
    console.log(r, "splineTube", r.qok.length, "steps", R, "extrudePts", al.length);
    Y = new THREE.Vector3();
    ab = new THREE.Vector3();
    X = new THREE.Vector3();
    console.log(al);
  }
  if (!B) {
    C = 0;
    ad = 0;
    aI = 0;
  }
  aG = void 0;
  W = void 0;
  aj = void 0;
  av = this;
  aq = [];
  n = this.vertices.length;
  ah = aF.extractPoints(ar);
  D = ah.shape;
  aH = ah.holes;
  e = !THREE.Shape.Utils.isClockWise(D);
  if (e) {
    D = D.reverse();
    W = 0;
    aj = aH.length;
    while (W < aj) {
      aG = aH[W];
      if (THREE.Shape.Utils.isClockWise(aG)) {
        aH[W] = aG.reverse();
      }
      W++;
    }
    e = false;
  }
  aK = THREE.Shape.Utils.triangulateShape(D, aH);
  debug(aK);
  aB = D;
  W = 0;
  aj = aH.length;
  while (W < aj) {
    aG = aH[W];
    D = D.concat(aG);
    W++;
  }
  Z = void 0;
  aa = void 0;
  O = void 0;
  L = void 0;
  az = void 0;
  at = D.length;
  c = void 0;
  F = aK.length;
  ap = void 0;
  A = aB.length;
  debug(at, F, A);
  ag = 180 / Math.PI;
  ak = [];
  V = 0;
  P = aB.length;
  T = P - 1;
  S = V + 1;
  while (V < P) {
    if (T === P) {
      T = 0;
    }
    if (S === P) {
      S = 0;
    }
    H = aB[V];
    G = aB[T];
    E = aB[S];
    ak[V] = aE(aB[V], aB[T], aB[S]);
    T++;
    S++;
    V++;
  }
  ax = [];
  g = void 0;
  aL = ak.concat();
  W = 0;
  aj = aH.length;
  while (W < aj) {
    aG = aH[W];
    g = [];
    V = 0;
    P = aG.length;
    T = P - 1;
    S = V + 1;
    while (V < P) {
      if (T === P) {
        T = 0;
      }
      if (S === P) {
        S = 0;
      }
      g[V] = aE(aG[V], aG[T], aG[S]);
      T++;
      S++;
      V++;
    }
    ax.push(g);
    aL = aL.concat(g);
    W++;
  }
  Z = 0;
  while (Z < C) {
    O = Z / C;
    V = 0;
    P = aB.length;
    while (V < P) {
      aa = ae * (Math.sin(O * Math.PI / 2));
      ay = aB[V];
      if (a > ae) {
        ay = aD(ay, ak[V], a - ae);
      }
      az = aD(ay, ak[V], aa);
      L = -ao * (Math.sin((1 - O) * Math.PI / 2));
      if (ao < aJ) {
        L -= aJ - ao;
      }
      N(az.x, az.y, L);
      V++;
    }
    W = 0;
    aj = aH.length;
    while (W < aj) {
      aa = ai * (Math.sin(O * Math.PI / 2));
      aG = aH[W];
      g = ax[W];
      V = 0;
      P = aG.length;
      while (V < P) {
        m = aG[V];
        if (I > ai) {
          m = aD(m, g[V], I - ai);
        }
        az = aD(m, g[V], aa);
        L = -aJ * (Math.sin((1 - O) * Math.PI / 2));
        if (ao > aJ) {
          L -= ao - aJ;
        }
        N(az.x, az.y, L);
        V++;
      }
      W++;
    }
    Z++;
  }
  V = 0;
  while (V < at) {
    if (V < at / 2) {
      aa = Math.max(a, ae);
    } else {
      aa = Math.max(I, ai);
    }
    az = (B ? aD(D[V], aL[V], aa) : D[V]);
    if (!q) {
      N(az.x, az.y, 0);
    } else {
      ab.copy(r.qok[0]).multiplyScalar(az.x);
      Y.copy(r.binormals[0]).multiplyScalar(az.y);
      X.copy(al[0]).add(ab).add(Y);
      N(X.x, X.y, X.z);
    }
    V++;
  }
  Q = void 0;
  Q = 1;
  while (Q <= R) {
    V = 0;
    while (V < at) {
      if (V < at / 2) {
        aa = Math.max(a, ae);
      } else {
        aa = Math.max(I, ai);
      }
      az = (B ? aD(D[V], aL[V], aa) : D[V]);
      if (!q) {
        N(az.x, az.y, J / R * Q);
      } else {
        ab.copy(r.qok[Q]).multiplyScalar(az.x);
        Y.copy(r.binormals[Q]).multiplyScalar(az.y);
        X.copy(al[Q]).add(ab).add(Y);
        N(X.x, X.y, X.z);
      }
      V++;
    }
    Q++;
  }
  Z = C - 1;
  while (Z >= 0) {
    O = Z / C;
    V = 0;
    P = aB.length;
    while (V < P) {
      aa = a * (Math.sin(O * Math.PI / 2));
      ay = aB[V];
      if (a < ae) {
        ay = aD(ay, ak[V], ae - a);
      }
      az = aD(ay, ak[V], aa);
      L = af * (Math.sin((1 - O) * Math.PI / 2));
      if (af < U) {
        L += U - af;
      }
      N(az.x, az.y, J + L);
      V++;
    }
    aa = am * Math.sin(O * Math.PI / 2);
    W = 0;
    aj = aH.length;
    while (W < aj) {
      aa = I * (Math.sin(O * Math.PI / 2));
      aG = aH[W];
      g = ax[W];
      V = 0;
      P = aG.length;
      while (V < P) {
        m = aG[V];
        if (I < ai) {
          m = aD(m, g[V], ai - I);
        }
        az = aD(m, g[V], aa);
        L = U * (Math.sin((1 - O) * Math.PI / 2));
        if (af > U) {
          L += af - U;
        }
        if (!q) {
          N(az.x, az.y, J + L);
        } else {
          N(az.x, az.y + al[R - 1].y, al[R - 1].x + L);
        }
        V++;
      }
      W++;
    }
    Z--;
  }
  ac();
  aw();
};

debug = function() {};

WorldUVGenerator = {
  generateTopUV: function(b, h, e, k, j, i) {
    var a, c, d, f, g, l;
    a = b.vertices[k].x;
    l = b.vertices[k].y;
    g = b.vertices[j].x;
    f = b.vertices[j].y;
    d = b.vertices[i].x;
    c = b.vertices[i].y;
    return [new THREE.Vector2(a, l), new THREE.Vector2(g, f), new THREE.Vector2(d, c)];
  },
  generateBottomUV: function(f, c, a, e, d, b) {
    return this.generateTopUV(f, c, a, e, d, b);
  },
  generateSideWallUV: function(m, l, b, t, B, A, v, u, a, n, s, r) {
    var c, d, e, f, g, h, i, j, k, o, p, q;
    j = m.vertices[B].x;
    h = m.vertices[B].y;
    f = m.vertices[B].z;
    q = m.vertices[A].x;
    p = m.vertices[A].y;
    o = m.vertices[A].z;
    e = m.vertices[v].x;
    d = m.vertices[v].y;
    c = m.vertices[v].z;
    k = m.vertices[u].x;
    i = m.vertices[u].y;
    g = m.vertices[u].z;
    if (Math.abs(h - p) < 0.01) {
      return [new THREE.Vector2(j, 1 - f), new THREE.Vector2(q, 1 - o), new THREE.Vector2(e, 1 - c), new THREE.Vector2(k, 1 - g)];
    } else {
      return [new THREE.Vector2(h, 1 - f), new THREE.Vector2(p, 1 - o), new THREE.Vector2(d, 1 - c), new THREE.Vector2(i, 1 - g)];
    }
  }
};

var NecklaceText, NeklaceLt;

NecklaceText = function(options) {
  var c, font, height, i, lt, obj, radius, size, str, textMesh, textWidth, _i, _len, _ref;
  font = options.font, str = options.str, radius = options.radius, size = options.size;
  size = size || (size = 5.4);
  height = 0.001;
  obj = new THREE.Object3D;
  obj.list = [];
  obj.add2 = function(e) {
    return this.add(e);
  };
  obj.add2To = function(e, pos) {
    return this.add(e);
  };
  obj.remove2 = function(index) {
    return this.remove(this.children[index]);
  };
  textWidth = 0;
  _ref = str.split("");
  for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
    lt = _ref[i];
    options.shift = textWidth;
    options.lt = lt;
    textMesh = NeklaceLt(options);
    textWidth += textMesh.width;
    obj.add2(textMesh);
  }
  c = 0;
  obj.textWidth = textWidth - c;
  obj.nowText = str;
  return obj;
};

NeklaceLt = function(options) {
  var c, font, height, index, lt, radius, size, textGeom, textMesh;
  font = options.font, lt = options.lt, radius = options.radius, size = options.size, index = options.index;
  size = size || (size = 5.4);
  height = 0.001;
  textGeom = new THREE.TextGeometry(lt, {
    font: font,
    size: size,
    height: height,
    bevelEnabled: true,
    bevelThickness: 0.5,
    bevelSize: 0.2,
    curveSegments: 10
  });
  textGeom.computeBoundingBox();
  textMesh = new THREE.Mesh(textGeom, silverMaterial.clone());
  textMesh.position.x = options.shift;
  textMesh.lt = lt;
  c = 0.5;
  switch (lt) {
    case "t":
      c = 1.6;
      break;
    case "l":
      c = 1.6;
      break;
    case "p":
      c = 1.7;
      break;
    case "f":
      c = 2.8;
      break;
    case "g":
      c = 1.4;
      break;
    case "j":
      c = 2.6;
      break;
    case "d":
      c = 1.6;
      break;
    case "y":
      c = 1.2;
      break;
    case "z":
      c = 1.2;
      break;
    case "x":
      c = 0.8;
      break;
    case "x":
      c = 0.8;
      break;
    case "д":
      c = 1.3;
      break;
    case "р":
      c = 1.4;
      break;
    case "у":
      c = 1.4;
      break;
    case "з":
      c = 1.2;
      break;
    case "б":
      c = 2.9;
      break;
    case "я":
      c = 0.6;
      break;
    case "а":
      c = 0.6;
      break;
    case "е":
      c = 0.4;
      break;
    case "в":
      c = 0.6;
  }
  textMesh.width = textGeom.boundingBox.max.x - textGeom.boundingBox.min.x - c * 1.2;
  return textMesh;
};

var RingText;

RingText = function(options, offsetsDisabled, messager) {
  var aT, angleTotal, c, chD, f, font, geom, height, qiW, qos, radius, shiftRotation, shiftStep, size, str, textGeom, textMesh, y, _i, _ref;
  if (offsetsDisabled == null) {
    offsetsDisabled = false;
  }
  if (messager == null) {
    messager = false;
  }
  font = options.font, str = options.str, radius = options.radius, size = options.size, height = options.height;
  radius = radius || (radius = 9.57);
  angleTotal = 0;
  aT = 0;
  shiftRotation = 0.01;
  shiftStep = 0.4;
  size = size || (size = 3.5);
  height = height || (height = 1.22);
  geom = new THREE.Geometry;
  c = 0;
  for (f = _i = 0, _ref = str.length; 0 <= _ref ? _i < _ref : _i > _ref; f = 0 <= _ref ? ++_i : --_i) {
    textGeom = new THREE.TextGeometry(str[f], {
      font: font,
      size: size,
      height: height
    });
    qos = function(b) {
      var a, d;
      b.computeBoundingBox();
      d = b.boundingBox;
      a = new THREE.Vector3();
      a.addVectors(d.min, d.max);
      a.multiplyScalar(-0.5);
      b.applyMatrix(new THREE.Matrix4().makeTranslation(a.x, a.y, a.z));
      b.computeBoundingBox();
      return a;
    };
    qos(textGeom);
    textGeom.textWidth = textGeom.boundingBox.max.x - textGeom.boundingBox.min.x;
    c += textGeom.textWidth / 2;
    chD = (function(_this) {
      return function(tArr, c, x) {
        var i, res, t, t1, t2, _j, _ref1;
        res = c;
        for (i = _j = 0, _ref1 = tArr.length; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; i = 0 <= _ref1 ? ++_j : --_j) {
          t = tArr[i];
          t1 = t[0];
          t2 = t[1];
          if (t2 === str[f] && t1 === str[f - 1]) {
            res -= x;
          } else if (t1 === str[f - 1] && t2 === "*") {
            res -= x;
          } else if (t2 === str[f] && t1 === "*") {
            res -= x;
          }
        }
        return res;
      };
    })(this);
    if ("W" === str[f]) {
      if ("A" === str[parseInt(f) - 1]) {
        c -= 1.35;
      }
      if ("L" === str[parseInt(f) - 1]) {
        c -= 1;
      }
    }
    if ("T" === str[f]) {
      if ("A" === str[parseInt(f) - 1]) {
        c -= 0.3;
      }
      if ("L" === str[parseInt(f) - 1]) {
        c -= 1.1;
      }
    }
    if ("V" === str[f]) {
      if ("A" === str[parseInt(f) - 1]) {
        c -= 1.45;
      }
      if ("L" === str[parseInt(f) - 1]) {
        c -= 1.35;
      }
      if ("P" === str[parseInt(f) - 1]) {
        c -= 0.6;
      }
      if ("F" === str[parseInt(f) - 1]) {
        c -= 0.6;
      }
      if ("D" === str[parseInt(f) - 1]) {
        c -= 0.4;
      }
      if ("B" === str[parseInt(f) - 1]) {
        c -= 0.5;
      }
      if ("R" === str[parseInt(f) - 1]) {
        c -= 0.3;
      }
    }
    if ("Y" === str[f]) {
      if ("A" === str[parseInt(f) - 1]) {
        c -= 1.45;
      }
      if ("L" === str[parseInt(f) - 1]) {
        c -= 1.35;
      }
      if ("P" === str[parseInt(f) - 1]) {
        c -= 0.5;
      }
      if ("F" === str[parseInt(f) - 1]) {
        c -= 0.5;
      }
      if ("D" === str[parseInt(f) - 1]) {
        c -= 0.5;
      }
      if ("B" === str[parseInt(f) - 1]) {
        c -= 0.5;
      }
      if ("R" === str[parseInt(f) - 1]) {
        c -= 0.5;
      }
      if ("O" === str[parseInt(f) - 1]) {
        c -= 0.5;
      }
    }
    if ("A" === str[f]) {
      if ("W" === str[parseInt(f) - 1]) {
        c -= 1.35;
      }
      if ("T" === str[parseInt(f) - 1]) {
        c -= 1.35;
      }
      if ("Y" === str[parseInt(f) - 1]) {
        c -= 1.45;
      }
      if ("V" === str[parseInt(f) - 1]) {
        c -= 1.45;
      }
      if ("P" === str[parseInt(f) - 1]) {
        c -= 1;
      }
      if ("F" === str[parseInt(f) - 1]) {
        c -= 0.55;
      }
      if ("D" === str[parseInt(f) - 1]) {
        c -= 0.4;
      }
    }
    if ("J" === str[f]) {
      if ("W" === str[parseInt(f) - 1]) {
        c -= 1;
      }
      if ("T" === str[parseInt(f) - 1]) {
        c -= 1.1;
      }
      if ("Y" === str[parseInt(f) - 1]) {
        c -= 1.4;
      }
      if ("V" === str[parseInt(f) - 1]) {
        c -= 1.35;
      }
      if ("P" === str[parseInt(f) - 1]) {
        c -= 0.3;
      }
      if ("F" === str[parseInt(f) - 1]) {
        c -= 0.5;
      }
    }
    if ("O" === str[f]) {
      if ("Y" === str[parseInt(f) - 1]) {
        c -= 0.2;
      }
    }
    if (/[а-яА-Я]/g.test(str[f])) {
      if ("Г" === str[parseInt(f) - 1]) {
        c += 0.3;
      }
    }
    if ("З" === str[f] || "Х" === str[f] || "Ф" === str[f] || "О" === str[f] || "Л" === str[f] || "Э" === str[f] || "Я" === str[f] || "С" === str[f]) {
      if ("Г" === str[parseInt(f) - 1]) {
        c -= 0.5;
      }
    }
    if ("У" === str[f] || "З" === str[f] || "Х" === str[f] || "Ъ" === str[f] || "Л" === str[f] || "Д" === str[f] || "Ж" === str[f] || "Э" === str[f] || "Т" === str[f]) {
      if ("О" === str[parseInt(f) - 1]) {
        c -= 0.15;
      }
    }
    if ("А" === str[f]) {
      if ("Г" === str[parseInt(f) - 1]) {
        c -= 0.9;
      }
    }
    if ("Д" === str[f]) {
      if ("Г" === str[parseInt(f) - 1]) {
        c -= 0.6;
      }
    }
    if ("О" === str[f]) {
      if ("М" === str[parseInt(f) - 1]) {
        c += 0.3;
      }
    }
    if ("О" === str[f]) {
      if ("К" === str[parseInt(f) - 1]) {
        c -= 0.0;
      }
    }
    if ("Т" === str[f]) {
      if ("А" === str[parseInt(f) - 1]) {
        c -= 0.6;
      }
    }
    if ("Р" === str[f] || "В" === str[f] || "Ш" === str[f] || "И" === str[f] || "М" === str[f] || "Й" === str[f] || "Г" === str[f] || "Щ" === str[f] || "Е" === str[f] || "Ц" === str[f] || "Ь" === str[f] || "Ё" === str[f] || "К" === str[f] || "Б" === str[f] || "Ю" === str[f]) {
      if ("П" === str[parseInt(f) - 1]) {
        c += 0.4;
      }
    }
    if ("Ч" === str[f] || "Ъ" === str[f]) {
      if ("П" === str[parseInt(f) - 1]) {
        c -= 0.2;
      }
    }
    if ("Ъ" === str[f]) {
      if ("Ь" === str[parseInt(f) - 1]) {
        c -= 0.4;
      }
    }
    if ("Ь" === str[f]) {
      if ("Ъ" === str[parseInt(f) - 1]) {
        c += 0.3;
      }
    }
    c = chD(["КС", "КФ", "КО", "СО", "ХО", "ТО", "ТЛ", "ТД", "ТС", "ТЯ", "ТО", "АЬ", "АЧ", "АФ", "ЮЛ", "ЮЪ", "ЮД", "ЮУ", "ЮЖ", "ЮЗ", "ЮТ", "ФЗ", "ФЖ", "ФУ", "ЖС", "ЖФ", "ЖО", "РА", "ХФ"], c, 0.25);
    c = chD(["АЪ", "ЦЪ", "ЦЧ", "ЦТ", "ЩЪ", "ЩЧ", "ЩТ", "ЪУ", "ЪЪ", "ФЪ"], c, 0.4);
    c = chD(["ФТ", "ЪТ", "ТА"], c, 0.6);
    c = chD(["*Ы"], c, 0.0);
    c = chD(["УА"], c, 0.69);
    if (messager) {
      c = chD(["Ф*"], c, -0.99);
    } else {
      c = chD(["Ф*"], c, 0.39);
    }
    c = chD(["ФЫ"], c, -0.49);
    if ("X" === str[f]) {
      if ("D" === str[parseInt(f) - 1]) {
        c -= 0.7;
      }
      if ("B" === str[parseInt(f) - 1]) {
        c -= 0.35;
      }
      if ("R" === str[parseInt(f) - 1]) {
        c -= 0.3;
      }
    }
    if ("У" === str[f]) {
      textGeom.applyMatrix(new THREE.Matrix4().makeTranslation(0, -0.05, 0));
    }
    if ("1" !== str[f]) {
      if ("1" === str[f - 1]) {
        c += 1.5;
      }
    }
    if ("I" === str[f] && f < str.length - 1) {
      if ("I" !== str[f - 1]) {
        c += 0.405;
      }
    }
    if ("I" !== str[f] && f < str.length - 1) {
      if ("I" === str[f - 1]) {
        c += 0.405;
      }
    }
    if (messager) {
      c += 0.8;
    }
    y = str[f] === "Ц" || str[f] === "Щ" ? -0.0 : str[f] === "Д" ? -0.0 : str[f] === "Й" ? -0.0 : str[f] === "Ё" ? 0.0 : 0;
    textGeom.applyMatrix(new THREE.Matrix4().makeTranslation(c, y, 0));
    y = str[f] === "Й" ? 1.00 : 1;
    y = str[f] === "Д" ? 1.01 : 1;
    textGeom.applyMatrix(new THREE.Matrix4().makeScale(1, y, 1));
    if (("S" === str[f] || "Z" === str[f] || "X" === str[f] || "Я" === str[f] || "З" === str[f] || "У" === str[f] || "Э" === str[f]) && f === 0) {
      textGeom.applyMatrix(new THREE.Matrix4().makeTranslation(-0.2, 0, 0));
    }
    if (("Ы" === str[f]) && f === 0) {
      textGeom.applyMatrix(new THREE.Matrix4().makeTranslation(-0.6, 0, 0));
    }
    if (("Ф" === str[f]) && !messager) {
      textGeom.applyMatrix(new THREE.Matrix4().makeTranslation(-3.2, -0.95, 0));
    }
    if (!("Ф" === str[f])) {
      c += textGeom.textWidth / 2 - 0.4;
    }
    if (("Ы" === str[f]) && !offsetsDisabled && f < str.length - 1) {
      c -= 0.3;
    }
    if (offsetsDisabled) {
      c += textGeom.textWidth - 0.8;
    }
    aT = c + 0.1;
    geom.merge(textGeom);
  }
  qiW = function(geometry, v3, c) {
    var e, g, h, i, t, vert, vertList, _results;
    vertList = geometry.vertices;
    c = Math.abs(0 - v3.z);
    g = 0 - v3.z;
    _results = [];
    for (i in vertList) {
      t = vertList[i];
      vert = vertList[i];
      f = vert.x / c;
      h = c * Math.sin(f);
      g = c * Math.cos(f);
      e = (new THREE.Vector2(h, g)).normalize();
      vert.x = h + v3.x + e.x * vert.z;
      _results.push(vert.z = g + v3.z + e.y * vert.z);
    }
    return _results;
  };
  textMesh = new THREE.Mesh(geom, silverMaterial.clone());
  if (messager) {
    qiW(geom, new THREE.Vector3(0, 0, -8.9));
  } else {
    qiW(geom, new THREE.Vector3(0, 0, -9.55));
  }
  if ("Ф" === str) {
    aT -= 0.15;
  }
  if (str.length >= 7) {
    aT -= 0.19;
  }
  if (str.length >= 3) {
    aT -= 0.1;
  }
  textMesh.angleTotal = aT * 0.107;
  textMesh.position.z = radius / textMesh.scale.x;
  textMesh.radius = radius;
  return textMesh;
};

var DiamondRing, buildGeometry, example, handleFiles, readAsciiStl, readBinaryStl, readObj, readStl, triangle;

DiamondRing = function(callback) {
  var combine, loader, manager, _ref;
  addRotateModelHandlers();
  _ref = [0, Math.PI], controls.minPolarAngle = _ref[0], controls.maxPolarAngle = _ref[1];
  controls.minDistance = 40;
  controls.maxDistance = 68;
  controls.center = new THREE.Vector3;
  camera.position.z = 60;
  camera.position.y = 55;
  camera.position.x = 0;
  combine = new THREE.Object3D;
  manager = new THREE.LoadingManager;
  loader = new THREE.OBJLoader(manager);
  if (loadedModels.diamondRing === null) {
    $("#ajax-loading").show();
    loadedModels.diamondRing = {};
    example("obj/diamond/backend/ring1.obj", function(object) {
      object.traverse(function(child) {
        if (child instanceof THREE.Mesh) {
          return child.material = silverMaterial.clone();
        }
      });
      object.position.y = 10;
      object.scale.x = object.scale.z = object.scale.y = config.p1.size * 0.08 * 0.08115;
      object.geometry.applyMatrix(new THREE.Matrix4().makeTranslation(0, -100, 0));
      object.userData.ring = true;
      combine.add(object);
      loadedModels.diamondRing = combine.clone();
      $("#ajax-loading").hide();
      return renderf();
    });
    example("obj/diamond/backend/diamond1.obj", function(object) {
      object.traverse(function(child) {
        if (child instanceof THREE.Mesh) {
          return child.material = silverMaterial.clone();
        }
      });
      object.position.y = 9.5;
      object.userData.diamond = true;
      object.geometry.applyMatrix(new THREE.Matrix4().makeTranslation(0, 88, 0));
      object.scale.x = object.scale.z = object.scale.y = config.p1.sizeDiamond * 0.075 * 0.07;
      combine.add(object);
      loadedModels.diamondRing = combine.clone();
      $("#ajax-loading").hide();
      return renderf();
    });
    combine.userData.model = true;
    combine.position.y = 0;
    scene.add(combine);
  } else {
    combine = loadedModels.diamondRing;
    changeMaterialNew(combine, modelParams.material);
    scene.add(combine);
  }
  modelParams.n = 1;
  modelParams.changeSizeDiamond = function(v) {
    var dia, mod, obj, _i, _j, _len, _len1, _ref1, _ref2;
    modelParams.sizeDiamond = v * 0.05;
    _ref1 = scene.children;
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      obj = _ref1[_i];
      if ((obj != null) && obj.userData.model === true) {
        _ref2 = obj.children;
        for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
          dia = _ref2[_j];
          if (!(dia.userData.diamond === true)) {
            continue;
          }
          mod = modelParams.n >= 2 && modelParams.n <= 5 ? 0.8 : 1;
          dia.scale.x = dia.scale.y = dia.scale.z = v * mod * 0.075 * 0.07;
        }
      }
    }
    modelParams.price();
    return renderf();
  };
  modelParams.changeDiamondModel = function(n, size) {
    var dia, model, obj, _i, _j, _len, _len1, _ref1, _ref2;
    n = parseInt(n);
    modelParams.n = n;
    $("#ajax-loading").show();
    model = null;
    _ref1 = scene.children;
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      obj = _ref1[_i];
      if (!(obj.userData.model === true)) {
        continue;
      }
      _ref2 = obj.children;
      for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
        dia = _ref2[_j];
        if ((dia != null) && dia.userData.diamond === true) {
          obj.remove(dia);
        }
      }
      model = obj;
    }
    example("obj/diamond/backend/diamond" + n + ".obj", function(object) {
      var down, mod;
      object.traverse(function(child) {
        if (child instanceof THREE.Mesh) {
          child.material = silverMaterial.clone();
          return changeMeshMaterial(child, modelParams.material);
        }
      });
      object.position.y = 9.5;
      object.userData.diamond = true;
      mod = n >= 2 && n <= 5 ? 0.8 : 1;
      down = (function() {
        switch (n) {
          case 6:
            return 30;
          case 5:
            return 10;
          case 4:
            return 10;
          default:
            return 0;
        }
      })();
      object.geometry.applyMatrix(new THREE.Matrix4().makeTranslation(0, 88 - down, 0));
      object.scale.x = object.scale.z = object.scale.y = modelParams.sizeDiamond * mod * 0.075 * 0.07;
      model.add(object);
      if (size != null) {
        modelParams.changeSizeDiamond(size);
      }
      $("#ajax-loading").hide();
      return renderf();
    });
    return renderf();
  };
  modelParams.changeRingModel = function(n) {
    var model, obj, ring, _i, _j, _len, _len1, _ref1, _ref2;
    $("#ajax-loading").show();
    model = null;
    _ref1 = scene.children;
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      obj = _ref1[_i];
      if (!(obj.userData.model === true)) {
        continue;
      }
      _ref2 = obj.children;
      for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
        ring = _ref2[_j];
        if ((ring != null) && ring.userData.ring === true) {
          obj.remove(ring);
        }
      }
      model = obj;
    }
    loader = new THREE.OBJLoader(manager);
    example("obj/diamond/backend/ring" + n + ".obj", function(object) {
      object.traverse(function(child) {
        if (child instanceof THREE.Mesh) {
          child.material = silverMaterial.clone();
          return changeMeshMaterial(child, modelParams.material);
        }
      });
      object.position.y = 10;
      object.userData.ring = true;
      object.scale.x = object.scale.z = object.scale.y = modelParams.size * 0.08 * 0.08115;
      object.geometry.applyMatrix(new THREE.Matrix4().makeTranslation(0, -100, 0));
      model.add(object);
      $("#ajax-loading").hide();
      return renderf();
    });
    return renderf();
  };
  modelParams.changeSize = function(v) {
    var obj, ring, _i, _j, _len, _len1, _ref1, _ref2;
    modelParams.size = v;
    _ref1 = scene.children;
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      obj = _ref1[_i];
      if ((obj != null) && obj.userData.model === true) {
        _ref2 = obj.children;
        for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
          ring = _ref2[_j];
          if (ring.userData.ring === true) {
            ring.scale.x = ring.scale.y = ring.scale.z = v * 0.08 * 0.08115;
          }
        }
      }
    }
    modelParams.price();
    return renderf();
  };
  modelParams.functionsTable["p-ring-diamond"] = modelParams.changeDiamondModel;
  modelParams.functionsTable["p-ring"] = modelParams.changeRingModel;
  modelParams.functionsTable["p-size-diamond"] = modelParams.changeSizeDiamond;
  modelParams.functionsTable["p-size"] = modelParams.changeSize;
  modelParams.functionsTable["p-selected-font"] = modelParams.changeFont;
  return modelParams.functionsTable["p-panel-text"] = modelParams.changeText;
};

readObj = function(oFile, vs, fs) {
  var f, i, l, ls, v;
  l = oFile.split(/[\r\n]/g);
  i = 0;
  while (i < l.length) {
    ls = l[i].trim().split(/\s+/);
    if (ls[0] === "v") {
      v = new THREE.Vector3(parseFloat(ls[1]) * 100, parseFloat(ls[2]) * 100, parseFloat(ls[3]) * 100);
      vs.push(v);
    }
    if (ls[0] === "f") {
      f = new THREE.Face3(parseFloat(ls[1]) - 1, parseFloat(ls[2]) - 1, parseFloat(ls[3]) - 1);
      fs.push(f);
    }
    i++;
  }
};

readAsciiStl = function(l, vs, fs) {
  var cs, f, face, i, line, ls, solid, v, vi, vis, vtest;
  solid = false;
  face = false;
  vis = [];
  vtest = {};
  i = 0;
  while (i < l.length) {
    line = l[i];
    if (solid) {
      if (line.search("endsolid") > -1) {
        solid = false;
      } else if (face) {
        if (line.search("endfacet") > -1) {
          face = false;
          f = new THREE.Face3(vis[0], vis[1], vis[2]);
          fs.push(f);
        } else if (line.search("vertex") > -1) {
          cs = line.substr(line.search("vertex") + 7);
          cs = cs.trim();
          ls = cs.split(/\s+/);
          v = new THREE.Vector3(parseFloat(ls[0]), parseFloat(ls[1]), parseFloat(ls[2]));
          vi = vs.length;
          if (cs in vtest) {
            vi = vtest[cs];
          } else {
            vs.push(v);
            vtest[cs] = vi;
          }
          vis.push(vi);
        }
      } else {
        if (line.search("facet normal") > -1) {
          face = true;
          vis = [];
        }
      }
    } else {
      if (line.search("solid") > -1) {
        solid = true;
      }
    }
    i++;
  }
  vtest = null;
};

triangle = function() {
  var _attr;
  if (arguments.length === 2) {
    this._buffer = arguments[0];
    this._sa = arguments[1];
  } else {
    this._sa = 0;
    this._buffer = new ArrayBuffer(50);
  }
  this.__byte = new Uint8Array(this._buffer);
  this.normal = new Float32Array(this._buffer, this._sa + 0, 3);
  this.v1 = new Float32Array(this._buffer, this._sa + 12, 3);
  this.v2 = new Float32Array(this._buffer, this._sa + 24, 3);
  this.v3 = new Float32Array(this._buffer, this._sa + 36, 3);
  _attr = new Int16Array(this._buffer, this._sa + 48, 1);
  Object.defineProperty(this, "attr", {
    get: function() {
      return _attr[0];
    },
    set: function(val) {
      _attr[0] = val;
    },
    enumerable: true
  });
};

readBinaryStl = function(l, vs, fs) {
  var bbuf, buf, f, face, i, j, k, normal, offset, trnr, v, vis, vtest;
  buf = new ArrayBuffer(l.length);
  bbuf = new Uint8Array(buf);
  i = 0;
  while (i < l.length) {
    bbuf[i] = l.charCodeAt(i);
    i++;
  }
  trnr = new Uint32Array(buf, 80, 1);
  vis = [0, 0, 0];
  vtest = {};
  offset = 84;
  face = new triangle();
  i = 0;
  while (i < trnr[0]) {
    j = 0;
    while (j < 50) {
      face.__byte[j] = bbuf[offset + j];
      j++;
    }
    v = new THREE.Vector3(face.v1[0], face.v1[1], face.v1[2]);
    k = "" + face.v1[0] + "," + face.v1[1] + "," + face.v1[2];
    vis[0] = vs.length;
    if (k in vtest) {
      vis[0] = vtest[k];
    } else {
      vs.push(v);
      vtest[k] = vis[0];
    }
    v = new THREE.Vector3(face.v2[0], face.v2[1], face.v2[2]);
    k = "" + face.v2[0] + "," + face.v2[1] + "," + face.v2[2];
    vis[1] = vs.length;
    if (k in vtest) {
      vis[1] = vtest[k];
    } else {
      vs.push(v);
      vtest[k] = vis[1];
    }
    v = new THREE.Vector3(face.v3[0], face.v3[1], face.v3[2]);
    k = "" + face.v3[0] + "," + face.v3[1] + "," + face.v3[2];
    vis[2] = vs.length;
    if (k in vtest) {
      vis[2] = vtest[k];
    } else {
      vs.push(v);
      vtest[k] = vis[2];
    }
    normal = new THREE.Vector3(face.normal[0], face.normal[1], face.normal[2]);
    f = new THREE.Face3(vis[0], vis[1], vis[2], normal);
    fs.push(f);
    offset += 50;
    i++;
  }
  vtest = null;
  bbuf = undefined;
  buf = null;
};

readStl = function(oFile, vs, fs) {
  var l, solididx;
  if (oFile instanceof ArrayBuffer) {
    return arrayBufferToBinaryString(oFile, function(stl) {
      readBinaryStl(stl, vs, fs);
    });
  }
  solididx = oFile.search("solid");
  if (solididx > -1 && solididx < 10) {
    l = oFile.split(/[\r\n]/g);
    readAsciiStl(l, vs, fs);
  } else {
    readBinaryStl(oFile, vs, fs);
  }
};

buildGeometry = function(l, f) {
  var Mx, My, Mz, cx, cy, cz, e1, e2, fs, geometry, i, max, mesh, mx, my, mz, n, v0, v1, v2, vs;
  vs = [];
  fs = [];
  if (f.name.indexOf(".obj") > -1) {
    readObj(l, vs, fs);
  } else if (f.name.indexOf(".stl") > -1) {
    readStl(l, vs, fs);
  } else {
    return;
  }
  for (i in fs) {
    if (i !== "last") {
      v0 = vs[fs[i].a];
      v1 = vs[fs[i].b];
      v2 = vs[fs[i].c];
      e1 = new THREE.Vector3(v1.x - v0.x, v1.y - v0.y, v1.z - v0.z);
      e2 = new THREE.Vector3(v2.x - v0.x, v2.y - v0.y, v2.z - v0.z);
      n = new THREE.Vector3(e1.y * e2.z - e1.z * e2.y, e1.z * e2.x - e1.x * e2.z, e1.x * e2.y - e1.y * e2.x);
      l = Math.sqrt(n.x * n.x + n.y * n.y + n.z * n.z);
      n.x /= l;
      n.y /= l;
      n.z /= l;
      fs[i].normal = n;
    }
  }
  mx = 1e10;
  my = 1e10;
  mz = 1e10;
  Mx = -1e10;
  My = -1e10;
  Mz = -1e10;
  for (i in vs) {
    if (mx > vs[i].x) {
      mx = vs[i].x;
    }
    if (my > vs[i].y) {
      my = vs[i].y;
    }
    if (mz > vs[i].z) {
      mz = vs[i].z;
    }
    if (Mx < vs[i].x) {
      Mx = vs[i].x;
    }
    if (My < vs[i].y) {
      My = vs[i].y;
    }
    if (Mz < vs[i].z) {
      Mz = vs[i].z;
    }
  }
  max = Math.max(Mx - mx, My - my, Mz - mz);
  max /= 200;
  cx = (Mx + mx) / 2;
  cy = (My + my) / 2;
  cz = (Mz + mz) / 2;
  for (i in vs) {
    vs[i].x -= cx;
    vs[i].y -= cy;
    vs[i].z -= cz;
    vs[i].x /= max;
    vs[i].y /= max;
    vs[i].z /= max;
  }
  mx = 1e10;
  my = 1e10;
  mz = 1e10;
  Mx = -1e10;
  My = -1e10;
  Mz = -1e10;
  for (i in vs) {
    if (mx > vs[i].x) {
      mx = vs[i].x;
    }
    if (my > vs[i].y) {
      my = vs[i].y;
    }
    if (mz > vs[i].z) {
      mz = vs[i].z;
    }
    if (Mx < vs[i].x) {
      Mx = vs[i].x;
    }
    if (My < vs[i].y) {
      My = vs[i].y;
    }
    if (Mz < vs[i].z) {
      Mz = vs[i].z;
    }
  }
  geometry = new THREE.Geometry();
  geometry.vertices = vs;
  geometry.faces = fs;
  mesh = new THREE.Mesh(geometry, silverMaterial.clone());
  return mesh;
};

handleFiles = function(f) {
  var file, reader;
  reader = new FileReader();
  reader.onload = function(e) {
    var oFile;
    oFile = e.target.result;
    buildGeometry(oFile, f[0]);
  };
  file = f[0];
  reader.readAsBinaryString(file);
};

example = function(file, onload) {
  var xhr;
  xhr = new XMLHttpRequest();
  xhr.open("GET", file, true);
  xhr.onload = function() {
    var f, oFile;
    oFile = this.response;
    f = {};
    f.name = file;
    onload(buildGeometry(oFile, f));
  };
  xhr.send("");
};

var Messager;

Messager = function(callback) {
  var combine, _ref;
  addRotateModelHandlers();
  _ref = [0, Math.PI], controls.minPolarAngle = _ref[0], controls.maxPolarAngle = _ref[1];
  controls.maxDistance = 28;
  camera.position.z = 100;
  camera.position.y = 60;
  if (loadedModels.messager === null) {
    $("#ajax-loading").show();
    loader.load("obj/carve/ring.obj", function(object) {
      var combine, text;
      object.traverse(function(child) {
        if (child instanceof THREE.Mesh) {
          return child.material = silverMaterial.clone();
        }
      });
      object.userData.ring = true;
      object.scale.x = object.scale.y = object.scale.z = config.p3.size * 0.05;
      combine = new THREE.Object3D;
      combine.userData.model = true;
      combine.add(object);
      text = RingText({
        str: "MYO",
        font: config.p3.defaultFont,
        radius: 8.9,
        size: 2.92
      }, false, true);
      text.userData.text = true;
      text.scale.x = text.scale.y = text.scale.z = config.p3.size * 0.05;
      text.position.z = text.radius * object.scale.x;
      combine.add(text);
      combine.rotation.y = Math.PI / 2;
      combine.position.y = 5;
      scene.add(combine);
      loadedModels.messager = combine.clone();
      $("#ajax-loading").hide();
      return renderf();
    });
  } else {
    combine = loadedModels.messager;
    changeMaterialNew(combine, modelParams.material);
    scene.add(combine);
  }
  modelParams.changeText = function(str) {
    var newText, obj, r, ring, text, _i, _j, _k, _len, _len1, _len2, _ref1, _ref2, _ref3, _results;
    _ref1 = scene.children;
    _results = [];
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      obj = _ref1[_i];
      if (!((obj != null) && obj.userData.model === true)) {
        continue;
      }
      r = null;
      _ref2 = obj.children;
      for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
        ring = _ref2[_j];
        if (ring.userData.ring === true) {
          r = ring;
        }
      }
      _ref3 = obj.children;
      for (_k = 0, _len2 = _ref3.length; _k < _len2; _k++) {
        text = _ref3[_k];
        if (!(text.userData.text === true)) {
          continue;
        }
        obj.remove(text);
        newText = RingText({
          str: str,
          font: config.p3.defaultFont,
          radius: 8.9,
          size: 2.92
        }, false, true);
        newText.userData.text = true;
        newText.scale.x = newText.scale.y = newText.scale.z = r.scale.x;
        newText.position.z = newText.radius * r.scale.x;
        obj.add(newText);
      }
      _results.push(changeMaterialNew(obj, modelParams.material));
    }
    return _results;
  };
  modelParams.changeFont = function(currentStr, font) {
    font || (font = config.p3.defaultFont);
    config.p3.defaultFont = font;
    return modelParams.changeText(currentStr, font);
  };
  modelParams.changeSize = function(v) {
    var obj, r, ring, text, _i, _j, _k, _len, _len1, _len2, _ref1, _ref2, _ref3;
    _ref1 = scene.children;
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      obj = _ref1[_i];
      if (!((obj != null) && obj.userData.model === true)) {
        continue;
      }
      r = null;
      _ref2 = obj.children;
      for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
        ring = _ref2[_j];
        if (!(ring.userData.ring === true)) {
          continue;
        }
        ring.scale.x = ring.scale.y = ring.scale.z = v * 0.05;
        r = ring;
      }
      _ref3 = obj.children;
      for (_k = 0, _len2 = _ref3.length; _k < _len2; _k++) {
        text = _ref3[_k];
        if (!(text.userData.text === true)) {
          continue;
        }
        text.scale.x = text.scale.y = text.scale.z = r.scale.x;
        text.position.z = text.radius * r.scale.x;
      }
    }
    modelParams.price();
    return renderf();
  };
  modelParams.functionsTable["p-selected-font"] = modelParams.changeFont;
  modelParams.functionsTable["p-panel-text"] = modelParams.changeText;
  return modelParams.functionsTable["p-size"] = modelParams.changeSize;
};

var Necklace;

Necklace = function(callback) {
  var combine;
  _global.rotate = false;
  removeRotateModelHandlers();
  addDriftModelHandlers();
  controls.minPolarAngle = 1.25;
  controls.maxPolarAngle = 1.4;
  controls.maxDistance = 30;
  controls.center = new THREE.Vector3;
  controls.camera = new THREE.Vector3;
  camera.position.x = 0;
  camera.position.y = 0;
  camera.position.z = 25;
  combine = new THREE.Object3D;
  combine.userData.model = true;
  if (loadedModels.necklace === null) {
    $("#ajax-loading").show();
    loader.load("obj/textnecklace/necklace.obj", function(object) {
      var clone, geom, mesh, mesh2, text;
      object.traverse(function(child) {
        if (child instanceof THREE.Mesh) {
          return child.material = silverMaterial.clone();
        }
      });
      text = NecklaceText({
        str: "myo",
        font: config.p4.defaultFont
      });
      text.userData.text = true;
      object.position.y = -19.0;
      object.position.x = -text.textWidth / 2;
      object.userData.first = true;
      clone = object.clone();
      clone.rotation.y = Math.PI;
      clone.position.y = -19.0;
      clone.position.x = text.textWidth / 2;
      clone.userData.first = void 0;
      clone.userData.second = true;
      combine.position.y = 27;
      text.position.y = -20;
      text.position.x = -text.textWidth / 2;
      geom = new THREE.TorusGeometry(0.6, 0.2, 32, 32);
      mesh = new THREE.Mesh(geom, silverMaterial.clone());
      mesh.position.y = -18.7;
      mesh.position.x = -text.textWidth / 2;
      mesh.userData.torus1 = true;
      mesh2 = new THREE.Mesh(geom.clone(), silverMaterial.clone());
      mesh2.userData.torus2 = true;
      mesh2.position.y = -18.7;
      mesh2.position.x = text.textWidth / 2;
      combine.add(mesh);
      combine.add(mesh2);
      combine.add(text);
      scene.add(combine);
      loadedModels.necklace = combine.clone();
      $("#ajax-loading").hide();
      return renderf();
    });
  } else {
    combine = loadedModels.necklace;
    scene.add(combine);
    changeMaterialNew(combine, modelParams.material);
  }
  modelParams.changeFont = function(currentStr, font) {
    font || (font = config.p4.defaultFont);
    config.p4.defaultFont = font;
    if (font === "norican" && currentStr.match(/[а-яА-ЯёЁ]/g)) {
      return false;
    }
    modelParams.changeText("");
    return modelParams.changeText(currentStr.toLowerCase());
  };
  modelParams.changeText = function(str, isEmpty) {
    var c1, c2, first, newText, obj, second, text, torus, torus1Y, torus2Y, _i, _j, _k, _l, _len, _len1, _len2, _len3, _len4, _len5, _m, _n, _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _results;
    str = str.toLowerCase();
    console.log('xxx: ' + str);
    if (str.length > 11) {
      camera.position.z = 40;
      controls.maxDistance = 40;
    } else {
      controls.maxDistance = 30;
    }
    torus1Y = 0;
    torus2Y = 0;
    _ref = scene.children;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      obj = _ref[_i];
      if (!((obj != null) && obj.userData.model === true)) {
        continue;
      }
      _ref1 = obj.children;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        text = _ref1[_j];
        if ((text != null) && text.userData.text === true) {
          obj.remove(text);
        }
      }
      newText = NecklaceText({
        str: str,
        font: config.p4.defaultFont
      });
      newText.userData.text = true;
      newText.position.y = -20;
      newText.position.x = -newText.textWidth / 2;
      obj.add(newText);
      c1 = 0;
      c2 = 0;
      if (str[0] === "л" || str[0] === "м") {
        c1 -= 1.0;
      }
      if (str.slice(-1 === "л" || str.slice(-1 === "м"))) {
        c2 -= 0.5;
      }
      _ref2 = obj.children.slice(0);
      for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
        torus = _ref2[_k];
        if ((torus != null) && (torus.userData.torus1 === true)) {
          torus.position.x = -newText.textWidth / 2 - c1;
        }
      }
      _ref3 = obj.children.slice(0);
      for (_l = 0, _len3 = _ref3.length; _l < _len3; _l++) {
        torus = _ref3[_l];
        if ((torus != null) && (torus.userData.torus2 === true)) {
          torus.position.x = newText.textWidth / 2 - c2;
        }
      }
      _ref4 = obj.children;
      for (_m = 0, _len4 = _ref4.length; _m < _len4; _m++) {
        first = _ref4[_m];
        if (first.userData.first === true) {
          first.position.x = -newText.geometry.textWidth / 2 - c1;
        }
      }
      _ref5 = obj.children;
      for (_n = 0, _len5 = _ref5.length; _n < _len5; _n++) {
        second = _ref5[_n];
        if (second.userData.second === true) {
          second.position.x = newText.geometry.textWidth / 2 - c2;
        }
      }
      _results.push(changeMaterialNew(obj, modelParams.material));
    }
    return _results;
  };
  modelParams.functionsTable["p-selected-font"] = modelParams.changeFont;
  return modelParams.functionsTable["p-panel-text"] = modelParams.changeText;
};

var Raw;

Raw = function(callback) {
  var combine, _ref;
  addRotateModelHandlers();
  _ref = [0, Math.PI], controls.minPolarAngle = _ref[0], controls.maxPolarAngle = _ref[1];
  controls.maxDistance = 38;
  camera.position.z = 100;
  camera.position.y = 80;
  combine = new THREE.Object3D;
  combine.userData.model = true;
  if (loadedModels.raw === null) {
    $("#ajax-loading").show();
    loader.load("obj/cross/left.obj", function(object) {
      var clone, text;
      object.traverse(function(child) {
        if (child instanceof THREE.Mesh) {
          return child.material = silverMaterial.clone();
        }
      });
      object.children.last().userData.ring1 = true;
      clone = object.children.last().clone();
      clone.userData.ring2 = true;
      combine.add(object.children.last());
      combine.add(clone);
      text = RingText({
        str: "MYO",
        font: config.p5.defaultFont,
        size: 3.585
      });
      text.userData.text = true;
      text.position.y = -0.03;
      combine.add(text);
      clone.rotation.y = Math.PI + text.angleTotal;
      combine.scale.x = combine.scale.y = combine.scale.z = config.p5.size * 0.05;
      combine.position.y = 10;
      scene.add(combine);
      loadedModels.raw = combine.clone();
      $("#ajax-loading").hide();
      return renderf();
    });
  } else {
    combine = loadedModels.raw;
    scene.add(combine);
    changeMaterialNew(combine, modelParams.material);
  }
  modelParams.changeText = function(str) {
    var newText, obj, r, ring, text, _i, _j, _k, _len, _len1, _len2, _ref1, _ref2, _ref3;
    _ref1 = scene.children;
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      obj = _ref1[_i];
      if (!((obj != null) && obj.userData.model === true)) {
        continue;
      }
      r = null;
      _ref2 = obj.children;
      for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
        ring = _ref2[_j];
        if (ring.userData.ring2 === true) {
          r = ring;
        }
      }
      _ref3 = obj.children;
      for (_k = 0, _len2 = _ref3.length; _k < _len2; _k++) {
        text = _ref3[_k];
        if (!(text.userData.text === true)) {
          continue;
        }
        obj.remove(text);
        newText = RingText({
          str: str,
          font: config.p5.defaultFont,
          size: 3.585
        });
        newText.userData.text = true;
        newText.position.y = -0.03;
        r.rotation.y = Math.PI + newText.angleTotal;
        obj.add(newText);
      }
    }
    return changeMaterialNew(combine, modelParams.material);
  };
  modelParams.changeFont = function(currentStr, font) {
    font || (font = config.p5.defaultFont);
    config.p5.defaultFont = font;
    return modelParams.changeText(currentStr, font);
  };
  modelParams.changeSize = function(v) {
    var obj, _i, _len, _ref1;
    _ref1 = scene.children;
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      obj = _ref1[_i];
      if ((obj != null) && obj.userData.model === true) {
        obj.scale.x = obj.scale.y = obj.scale.z = v * 0.05;
      }
    }
    modelParams.price();
    return renderf();
  };
  modelParams.functionsTable["p-selected-font"] = modelParams.changeFont;
  modelParams.functionsTable["p-panel-text"] = modelParams.changeText;
  modelParams.functionsTable["p-size"] = modelParams.changeSize;
  return modelParams.functionsTable["p-price"] = modelParams.price;
};

var addDriftModelHandlers, addRotateModelHandlers, camera, changeMaterialNew, changeMeshMaterial, controls, createMaterial, driftModelEndHandler, driftModelStartHandler, initGraphics, loader, manager, removeDriftModelHandlers, removeRotateModelHandlers, render, renderf, rotateModelEndHandler, rotateModelStartHandler, scene, silverMaterial, _global;

render = null;

scene = null;

camera = null;

manager = null;

controls = null;

silverMaterial = null;

_global = {
  rotate: true,
  drift: true,
  driftMax: 0.04,
  driftSign: 1,
  driftStep: 0.00003,
  driftSmooth: 0.00006
};

loader = null;

initGraphics = function() {
  var ambientLight, animate, directionalLight, lastTime, _ref, _ref1, _ref2;
  render = new THREE.WebGLRenderer({
    antialias: true,
    alpha: true
  });
  render.setSize(size.width, size.height);
  render.setClearColor(0xeeeeee);
  $("#cont").append(render.domElement);
  camera = new THREE.PerspectiveCamera(70, size.width / size.height, 1, 1000);
  camera.position.z = 100;
  camera.position.y = 80;
  controls = new THREE.OrbitControls(camera, $("#cont")[0]);
  _ref = [false, true], controls.noZoom = _ref[0], controls.noPan = _ref[1];
  controls.rotateSpeed = 0.5;
  _ref1 = [38, 18], controls.maxDistance = _ref1[0], controls.minDistance = _ref1[1];
  _ref2 = [0, Math.PI], controls.minPolarAngle = _ref2[0], controls.maxPolarAngle = _ref2[1];
  controls.addEventListener('change', renderf);
  $("#cont").on("mouseout", function() {
    return controls.stop();
  });
  manager = new THREE.LoadingManager;
  loader = new THREE.OBJLoader(manager);
  scene = new THREE.Scene;
  ambientLight = new THREE.AmbientLight(0x888888);
  scene.add(ambientLight);
  directionalLight = new THREE.DirectionalLight(0xffffff);
  directionalLight.position.set(1, 1, 1).normalize();
  scene.add(directionalLight);
  lastTime = 0;
  createMaterial();
  animate = function() {
    var dt, obj;
    requestAnimationFrame(animate);
    dt = new Date().getTime() - lastTime;
    lastTime = new Date().getTime();
    controls.update();
    if (_global.rotate) {
      scene.children.last().rotation.y += 0.0005 * dt;
      renderf();
    }
    if (_global.drift) {
      obj = scene.children.last();
      obj.rotation.z += _global.driftStep * _global.driftSign * dt;
      if (obj.rotation.z > _global.driftMax) {
        obj.rotation.z = _global.driftMax;
        _global.driftSign = -1;
      }
      if (obj.rotation.z < -_global.driftMax) {
        obj.rotation.z = -_global.driftMax;
        _global.driftSign = 1;
      }
      return renderf();
    }
  };
  return animate();
};

renderf = function() {
  return render.render(scene, camera);
};

changeMeshMaterial = function(mesh, type) {
  if (mesh instanceof THREE.Mesh) {
    if (type === "gold") {
      mesh.material.specular.setHex(0xaa5500);
      mesh.material.color.setHex(0xaa5500);
      return mesh.material.emissive.setHex(0xaaaa44);
    } else if (type === "whiteGold") {
      mesh.material.specular.setHex(0xffffff);
      mesh.material.color.setHex(0xfefcff);
      return mesh.material.emissive.setHex(0xaaaaaa);
    } else if (type === "silver") {
      mesh.material.specular.setHex(0xffffff);
      mesh.material.color.setHex(0xaaaaaa);
      return mesh.material.emissive.setHex(0x555555);
    }
  }
};

changeMaterialNew = function(obj, type) {
  var child, _i, _len, _ref;
  _ref = obj.children;
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    child = _ref[_i];
    changeMeshMaterial(child, type);
    changeMaterialNew(child, type);
  }
  return renderf();
};

createMaterial = function(type) {
  var envMap, urls;
  urls = ["im/px.jpg", "im/nx.jpg", "im/py.jpg", "im/ny.jpg", "im/pz.jpg", "im/nz.jpg"];
  envMap = THREE.ImageUtils.loadTextureCube(urls);
  envMap.format = THREE.RGBFormat;
  return silverMaterial = new THREE.MeshPhongMaterial({
    specular: 0xffffff,
    color: 0xaaaaaa,
    emissive: 0x555555,
    envMap: envMap,
    shininess: 100
  });
};

addRotateModelHandlers = function() {
  removeDriftModelHandlers();
  _global.rotate = true;
  controls.addEventListener('start', rotateModelStartHandler, false);
  return controls.addEventListener('end', rotateModelEndHandler, false);
};

removeRotateModelHandlers = function() {
  clearTimeout(_global.drifttimeout);
  clearTimeout(_global.timeout);
  _global.rotate = false;
  controls.removeEventListener('start', rotateModelStartHandler, false);
  return controls.removeEventListener('end', rotateModelEndHandler, false);
};

rotateModelStartHandler = function() {
  clearTimeout(_global.timeout);
  return _global.rotate = false;
};

rotateModelEndHandler = function() {
  return _global.timeout = setTimeout((function() {
    if (!_global.drift) {
      return _global.rotate = true;
    }
  }), 4000);
};

driftModelStartHandler = function() {
  clearTimeout(_global.drifttimeout);
  _global.drift = false;
  return _global.rotate = false;
};

driftModelEndHandler = function() {
  return _global.drifttimeout = setTimeout(function() {
    _global.drift = true;
    return _global.rotate = false;
  }, 100);
};

removeDriftModelHandlers = function() {
  clearTimeout(_global.drifttimeout);
  clearTimeout(_global.timeout);
  _global.drift = false;
  controls.removeEventListener('start', driftModelStartHandler, false);
  return controls.removeEventListener('end', driftModelEndHandler, false);
};

addDriftModelHandlers = function() {
  removeRotateModelHandlers();
  _global.drift = true;
  _global.rotate = false;
  controls.addEventListener('start', driftModelStartHandler, false);
  return controls.addEventListener('end', driftModelEndHandler, false);
};

var exportFaces, exportSTL, fromJSON, initPanel, loadModel, loadedModels, modelParams, size;

Array.prototype.last = function() {
  return this[this.length - 1];
};

size = {
  width: $("#cont").width(),
  height: $("#cont").height()
};

modelParams = {
  material: "silver",
  functionsTable: {
    "p-model-id": function(v) {
      return console.log(v);
    },
    "p-material": function(v) {
      return modelParams.material = v;
    }
  },
  changeSize: function(v) {
    var obj, ring, _i, _j, _len, _len1, _ref, _ref1;
    modelParams.size = v;
    _ref = scene.children;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      obj = _ref[_i];
      if ((obj != null) && obj.userData.model === true) {
        _ref1 = obj.children;
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          ring = _ref1[_j];
          if (ring.userData.ring === true) {
            ring.scale.x = ring.scale.y = ring.scale.z = v * 0.05;
          }
        }
      }
    }
    modelParams.price();
    return renderf();
  }
};

loadedModels = {
  diamondRing: null,
  mring: null,
  messager: null,
  necklace: null,
  raw: null
};

$(document).ready(function() {
  var n;
  $(window).bind("beforeunload", function(e) {
    $("canvas").hide();
    return e.preventDefault();
  });
  $(window).on('hashchange', function() {
    var n;
    n = parseInt(location.hash[1]);
    return loadModel(n);
  });
  if (!Detector.webgl) {
    return $("#no-webgl").show();
  } else {
    n = parseInt(location.hash[1]);
    initGraphics();
    n = isNaN(n) ? 1 : n;
    return loadModel(n);
  }
});

loadModel = function(n) {
  var cfg, model, obj, _i, _len, _ref;
  $("canvas").hide();
  cfg = config["p" + n];
  $("#panel").html("");
  $("#panel").css("height", cfg.height);
  $("#menu a[pid]").parent().removeClass("active-menu");
  $("#menu a[pid='p" + n + "']").parent().addClass("active-menu");
  _ref = scene.children;
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    obj = _ref[_i];
    if ((obj != null) && obj.userData.model === true) {
      if (typeof scene !== "undefined" && scene !== null) {
        scene.remove(obj);
      }
    }
  }
  $("#panel").load("panels/p" + n + ".html", function() {
    $("form").attr("action", formPost);
    $("#submit").click(function() {
      return $("form").submit();
    });
    $('.gold').click(function() {
      changeMaterialNew(scene, "gold");
      modelParams.material = "gold";
      return $("input[name=p-material]").val(modelParams.material);
    });
    $('.whiteGold').click(function() {
      changeMaterialNew(scene, "whiteGold");
      modelParams.material = "whiteGold";
      return $("input[name=p-material]").val(modelParams.material);
    });
    $('.silver').click(function() {
      changeMaterialNew(scene, "silver");
      modelParams.material = "silver";
      return $("input[name=p-material]").val(modelParams.material);
    });
    $('.silver, .gold, .whiteGold').tooltip({
      position: {
        my: "center top",
        at: "center bottom"
      }
    });
    initPanel();
    return $("canvas").show();
  });
  if (cfg != null) {
    cfg.model();
  }
  model = null;
  modelParams.price = (function(_this) {
    return function() {
      $("#price").html((cfg.price(model)).toFixed(2));
      return $("input[name=p-price]").val(parseInt($("#price").html()));
    };
  })(this);
  return modelParams.functionsTable["p-price"] = modelParams.price;
};

fromJSON = function(json) {
  var key, obj, value;
  obj = JSON.parse(json);
  $("input[name=p-material]").val(obj["p-material"]);
  modelParams.functionsTable["p-material"](obj["p-material"]);
  for (key in obj) {
    value = obj[key];
    if (!(key !== "p-model-id" && key !== "p-material" && key !== "p-price")) {
      continue;
    }
    $("input[name=" + key + "]").val(value);
    console.log("" + key + " -> " + value);
    if (key === "p-selected-font") {
      modelParams.functionsTable["" + key](obj["p-panel-text"], value);
    } else if (key === "p-ring-diamond") {
      modelParams.functionsTable["" + key](value, obj["p-size-diamond"]);
    } else if (key !== "p-size-diamond") {
      modelParams.functionsTable["" + key](value);
    }
  }
  modelParams.price();
};

exportFaces = function(mesh, matrix) {
  var exportFacesMesh, lines, obj3d, _i, _len, _ref;
  exportFacesMesh = function(obj, geometry) {
    var a, b, c, face, faces, lines, v, vertices, _i, _ref;
    lines = [];
    geometry.computeFaceNormals();
    faces = geometry.faces;
    vertices = geometry.vertices;
    for (v = _i = 0, _ref = faces.length; 0 <= _ref ? _i <= _ref : _i >= _ref; v = 0 <= _ref ? ++_i : --_i) {
      face = faces[v];
      if (face != null) {
        a = vertices[face.a];
        a = new THREE.Vector3(a.x, a.y, a.z);
        a.applyMatrix4(obj.matrix);
        b = vertices[face.b];
        b = new THREE.Vector3(b.x, b.y, b.z);
        b.applyMatrix4(obj.matrix);
        c = vertices[face.c];
        c = new THREE.Vector3(c.x, c.y, c.z);
        c.applyMatrix4(obj.matrix);
        lines.push("facet normal " + face.normal.x.toExponential() + " " + face.normal.y.toExponential() + " " + face.normal.z.toExponential() + "");
        lines.push("    outer loop");
        lines.push("        vertex  " + a.x.toExponential() + " " + a.y.toExponential() + " " + a.z.toExponential() + "");
        lines.push("        vertex  " + b.x.toExponential() + " " + b.y.toExponential() + " " + b.z.toExponential() + "");
        lines.push("        vertex  " + c.x.toExponential() + " " + c.y.toExponential() + " " + c.z.toExponential() + "");
        lines.push("    endloop");
        lines.push("endfacet");
      }
    }
    return lines;
  };
  lines = [];
  _ref = mesh.children;
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    obj3d = _ref[_i];
    if ((obj3d != null) && (obj3d.geometry != null)) {
      lines = lines.concat(exportFacesMesh(obj3d, obj3d.geometry));
    }
  }
  if (mesh.children.length === 0) {
    if ((mesh != null) && (mesh.geometry != null)) {
      lines = lines.concat(exportFacesMesh(mesh, mesh.geometry));
    }
  }
  return lines;
};

exportSTL = function() {
  var blob, func, obj, result, stllines, _i, _len, _ref;
  stllines = [];
  stllines.push("solid name");
  func = (function(_this) {
    return function(objmodel) {
      var x, _i, _len, _ref, _results;
      _ref = objmodel.children;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        x = _ref[_i];
        if (!((x.userData.second == null) && (x.userData.first == null))) {
          continue;
        }
        stllines = stllines.concat(exportFaces(x, objmodel.matrix));
        _results.push(func(x));
      }
      return _results;
    };
  })(this);
  _ref = scene.children;
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    obj = _ref[_i];
    if (obj.userData.model === true) {
      func(obj);
    }
  }
  stllines.push("endsolid name");
  result = stllines.join("\n");
  console.log(result);
  blob = new Blob([result], {
    type: "text/plaincharset=utf-8"
  });
  return saveAs(blob, "model.stl");
};

(function($) {
  $.fn.extend({
    donetyping: function(callback, timeout) {
      var doneTyping, timeoutReference;
      timeout = timeout || 1e3;
      timeoutReference = void 0;
      doneTyping = function(el) {
        if (!timeoutReference) {
          return;
        }
        timeoutReference = null;
        callback.call(el);
      };
      return this.each(function(i, el) {
        var $el;
        $el = $(el);
        $el.is(":input") && $el.on("input", function() {
          if (timeoutReference) {
            clearTimeout(timeoutReference);
          }
          timeoutReference = setTimeout(function() {
            doneTyping(el);
          }, timeout);
        }).blur(function() {
          doneTyping(el);
        });
      });
    }
  });
})(jQuery);

initPanel = function() {
  var setSelectionRange;
  $("a.plus").click(function() {
    var v;
    v = parseFloat($("#p-size-display").val());
    if (v < 25) {
      $("#p-size-display").val("" + ((v + 0.1).toFixed(2).toString()) + " мм");
      $("input[name=p-size]").val(v + 0.1);
      modelParams.changeSize(v + 0.1);
      return config.p1.size = v + 1;
    }
  });
  $("a.minus").click(function() {
    var v;
    v = parseFloat($("#p-size-display").val());
    if (v > 10) {
      $("#p-size-display").val("" + ((v - 0.1).toFixed(2).toString()) + " мм");
      $("input[name=p-size]").val(v - 0.1);
      modelParams.changeSize(v - 0.1);
      return config.p1.size = v - 1;
    }
  });
  $("#p-size-display").on("change", function() {
    var v;
    v = parseFloat($("#p-size-display").val());
    if (!Number.isNaN(v)) {
      if (v >= 10 && v <= 25) {
        $("#p-size-display").val("" + (v.toFixed(2).toString()) + " мм");
      } else if (v <= 10) {
        $("#p-size-display").val("10 мм");
      } else if (v >= 25) {
        $("#p-size-display").val("25 мм");
      }
    } else {
      $("#p-size-display").val("18 мм");
    }
    modelParams.changeSize(parseFloat($("#p-size-display").val()));
    return $("input[name=p-size]").val(parseFloat($("#p-size-display").val()));
  });
  $("input[name=p-size]").val(config.p1.size);
  $("#p-size-display").val("" + config.p1.size + " мм");
  $("#slider").slider({
    range: "min",
    value: config.p1.sizeDiamond,
    min: 9.6,
    max: 13.0,
    step: 0.1,
    slide: function(event, ui) {
      var v;
      v = parseFloat(ui.value);
      $("#amount").html("" + (v.toFixed(2)) + " мм");
      $("input[name=p-size-diamond]").val(v);
      return modelParams.changeSizeDiamond(v);
    }
  });
  $("#amount").html(parseFloat($("#slider").slider("value")).toFixed(2) + " мм");
  $("input[name=p-size-diamond]").val(config.p1.sizeDiamond);
  $('a.yearstyle').click(function() {
    var diamondId;
    $('.yearstyle').removeClass('current');
    $(this).addClass('current');
    modelParams.sizeDiamond = parseFloat($("#amount").html());
    diamondId = parseInt($(this).attr("data-obj"));
    $("input[name=p-ring-diamond]").val(diamondId);
    return modelParams.changeDiamondModel(diamondId);
  });
  $(".ring_select").click(function() {
    var ringId;
    modelParams.size = parseFloat($("#p-size-display").val());
    ringId = parseInt($(this).attr("data-obj"));
    modelParams.changeRingModel(ringId);
    return $("input[name=p-ring]").val(ringId);
  });
  $("#height-ring").slider({
    range: "min",
    value: config.p2.ringHeight,
    min: 1.5,
    max: 4,
    step: 0.1,
    slide: function(event, ui) {
      var v;
      v = parseFloat(ui.value);
      $("#height-ring-display").html(v.toFixed(2) + " мм");
      modelParams.changeHeight(v);
      $("input[name=p-height]").val(v);
    }
  });
  $("#height-ring-display").html(config.p2.ringHeight.toFixed(2) + " мм");
  $("input[name=p-height]").val(config.p2.ringHeight);
  $("#thickness-ring").slider({
    range: "min",
    value: config.p2.ringThickness,
    min: 1.5,
    max: 2.5,
    step: 0.1,
    slide: function(event, ui) {
      var v;
      v = parseFloat(ui.value);
      $("#thickness-ring-display").html(v.toFixed(2) + " мм");
      modelParams.changeThickness(v);
    }
  });
  $("#thickness-ring-display").html(config.p2.ringThickness.toFixed(2) + " мм");
  $("input[name=p-thickness]").val(config.p2.ringThickness);
  $("#height-text").slider({
    range: "min",
    value: config.p2.fontHeight,
    min: 3,
    max: 6,
    step: 0.1,
    slide: function(event, ui) {
      var v;
      v = parseFloat(ui.value);
      $("#height-text-display").html(v.toFixed(2) + " мм");
      modelParams.changeFontHeight(v);
      $("input[name=p-text-height]").val(v);
    }
  });
  $("#height-text-display").html(config.p2.fontHeight.toFixed(2) + " мм");
  $("input[name=p-text-height]").val(config.p2.fontHeight);
  $("#side-smooth").slider({
    range: "min",
    value: config.p2.sideSmooth,
    min: 0,
    max: 1,
    step: 0.1,
    slide: function(event, ui) {
      var v;
      v = parseFloat(ui.value);
      $("#side-smooth-display").html(v.toFixed(2) + " мм");
      modelParams.changeSideSmooth(v);
      $("input[name=p-side-smooth]").val(v);
    }
  });
  $("#side-smooth-display").html(config.p2.sideSmooth.toFixed(2) + " мм");
  $("input[name=p-side-smooth]").val(config.p2.sideSmooth);
  $("#font-select-list_SelectBoxItArrowContainer").click(function(e) {
    $("#font-select-list_SelectBoxItOptions").toggle();
    e.stopPropagation();
  });
  $(":not(#font-select-list_SelectBoxItArrowContainer)").click(function(event) {
    if (!$(event.target).is("#font-select-list_SelectBoxItOptions")) {
      $("#font-select-list_SelectBoxItOptions").hide();
    }
  });
  $(".selectboxit-option").click(function() {
    var text;
    $(".selectboxit-focus").removeClass("selectboxit-focus");
    $(this).addClass("selectboxit-focus");
    text = $(this).find("a").clone().children().remove().end().text();
    modelParams.changeFont($('#text-input').val(), text.trim());
    $("input[name=p-selected-font]").val(text.trim());
  });
  $("input[name=p-selected-font]").val(config.p3.defaultFont);
  if (typeof textMaxLength !== "undefined" && textMaxLength !== null) {
    $("#text-input").bind("input", textMaxLength);
  }
  setSelectionRange = function(input, selectionStart, selectionEnd) {
    var doGetCaretPosition, end, range, start;
    doGetCaretPosition = function(oField) {
      var iCaretPos, oSel;
      iCaretPos = 0;
      if (document.selection) {
        oField.focus();
        oSel = document.selection.createRange();
        oSel.moveStart('character', -oField.value.length);
        iCaretPos = oSel.text.length;
      } else if (oField.selectionStart || oField.selectionStart === '0') {
        iCaretPos = oField.selectionStart;
      }
      return iCaretPos;
    };
    start = input.selectionStart;
    end = input.selectionEnd;
    if (start !== end) {
      return;
    }
    if (input.setSelectionRange) {
      input.focus();
      input.setSelectionRange(selectionStart, selectionEnd);
    } else if (input.createTextRange) {
      range = input.createTextRange();
      range.collapse(true);
      range.moveEnd('character', selectionEnd);
      range.moveStart('character', selectionStart);
      range.select();
    }
  };
  $("#text-input").bind("keydown", function() {
    return setSelectionRange($(this)[0], $(this).val().length, $(this).val().length);
  });
  return modelParams.price();
};
