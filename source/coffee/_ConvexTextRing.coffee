ConvexTextRing = (callback) ->
	_global.rotate = true
	do addRotateModelHandlers

	[controls.minPolarAngle, controls.maxPolarAngle] = [0, Math.PI]
	controls.maxDistance = 38
	camera.position.z = 100
	camera.position.y = 80
	$("#ajax-loading").show()

	combine = new THREE.Object3D
	combine.userData.model = true

	create = (opts,regenRing=true) =>
		options = 
			text: unless modelParams.str? then "MYOMYO" else modelParams.str
			font: config.p2.defaultFont
			sideSmooth: 0.5
			bottomSmooth: config.p2.sideSmooth
			thickness: 2
			ringSize: 18
			height: 2.5
			materialName: "Silver"
			fontHeight: 4
			distance: 4

		textRadius = 10
		fontThickness = 0
		fontHeight = options.fontHeight
		maxTextCount = 0

		extend = (object, properties) ->
		  for key, val of properties
		    object[key] = val
		  object
		
		options = extend options, opts

		
		# параметры
		options.frontContourBevelThickness = options.sideSmooth * (options.height - 0.2)
		options.frontContourBevelSize = options.bottomSmooth * (options.thickness - 0.2)
		options.backContourBevelThickness = 0
		options.backContourBevelSize = 0

		# расчет радуисов
		s = 0.1
		o = Math.max(options.frontContourBevelThickness, 0.1)
		r = 0.1
		amount = Math.max(0.1, options.height - o - r)
		p = options.ringSize / 2 + s
		n = options.ringSize / 2 + options.thickness - options.frontContourBevelSize

		if p > n
			n = p + 1

		options.amount = amount

		# Круг и дырка
		t = new THREE.Shape
		t.moveTo n, 0
		t.absarc 0, 0, n, 0, Math.PI * 2, false
		e = new THREE.Path
		e.moveTo p, 0
		e.absarc 0, 0, p, 0, Math.PI * 2, true
		t.holes.push(e)

		# Специфичный ExtrudeGeometry
		a = new qyt t, options

		# Mesh 1
		v = new THREE.Mesh a, silverMaterial.clone()
		v.userData.meshDown = true
		v.rotation.x = Math.PI / 2 # поворот
		v.position.y = -options.fontHeight/2
		# Добавляем
		combine.add v

		if regenRing
			if options.bottomSmooth != 1.0
				geom = new THREE.RingGeometry p-0.0, n+0.1, 32, 32, 0, Math.PI*2
				ring1 = new THREE.Mesh geom, silverMaterial.clone()
				ring1.userData.ringUp = true
				ring1.rotation.x = -Math.PI/2
				ring1.position.y = options.fontHeight/2 + options.height - 0.07

				ring2 = ring1.clone()
				ring2.userData.ringDown = true
				ring2.rotation.x = Math.PI/2
				ring2.position.y = -options.fontHeight/2 - options.height + 0.07

				combine.add ring1
				combine.add ring2


		# Mesh 2 - нижнее кольцо
		b = new THREE.Mesh a, silverMaterial.clone()
		b.userData.meshUp = true
		b.rotation.x = -Math.PI / 2
		b.position.y = options.fontHeight/2
		# Добавляем второе кольцо 
		combine.add b

		changeMaterialNew combine, modelParams.material

	createText = (opts) =>
		options = 
			text: "MYOMYO"
			font: config.p2.defaultFont
			sideSmooth: 0.5
			bottomSmooth: config.p2.sideSmooth
			thickness: 3
			ringSize: 18
			height: 2.5
			materialName: "Silver"
			fontHeight: 4
			distance: 1000

		console.log options
		textRadius = 0
		fontThickness = 0
		fontHeight = options.fontHeight
		maxTextCount = 0

		extend = (object, properties) ->
		  for key, val of properties
		    object[key] = val
		  object
		
		options = extend options, opts

		# параметры
		options.frontContourBevelThickness = options.sideSmooth * (options.height - 0.2)
		options.frontContourBevelSize = options.bottomSmooth * (options.thickness - 0.2)
		options.backContourBevelThickness = 0
		options.backContourBevelSize = 0

		# расчет радуисов
		s = 0.1
		o = Math.max(options.frontContourBevelThickness, 0.1)
		r = 0.1
		amount = Math.max(0.1, options.height - o - r)
		p = options.ringSize / 2 + s
		n = options.ringSize / 2 + options.thickness - options.frontContourBevelSize

		if p > n
			n = p + 1

		options.amount = amount

		m = (p + p + options.thickness - 0.2 - options.fontHeight*0.09) / 2

		options =
			font: opts.font
			text: opts.text
			fontHeight: options.fontHeight
			size: 2
			fontThickness: options.fontThickness

		# m = 6

		t = new THREE.Shape()
		t.moveTo m, 0
		t.absarc 0, 0, m, 2 * Math.PI, 0, true
		q = t.getSpacedPoints(100)

		qtb = (b, a) ->
			new THREE.Vector3(b.x, 0, b.y)

		qrX = (c, a) ->
			e = []
			for b of c
				d = qtb(c[b], a)
				e.push d
			return e

		k = new THREE.SplineCurve3 qrX(q)
		options.qup = k

		i = new qtE(@qab, options)
		i.create()

		i.text.position.y = 0
		i.text.position.x = 0
		i.text.position.z = 0
		i.text.userData.text = true

		combine.add i.text

		changeMaterialNew combine, modelParams.material


	modelParams.height = config.p2.ringHeight
	modelParams.heightv = modelParams.height
	modelParams.thickness = config.p2.ringThickness
	modelParams.fontThickness = modelParams.thickness 
	modelParams.bottomSmooth = config.p2.sideSmooth
	modelParams.font = config.p2.defaultFont
	modelParams.fontHeight = config.p2.fontHeight

	
	modelParams.changeHeight = (v) ->
		for obj in scene.children when obj? and obj.userData.model == true
			m = null
			for mesh in obj.children when mesh? and mesh.userData.meshDown == true
				mesh.scale.z = v*0.4
				m = mesh
			for ring in obj.children when ring? and ring.userData.ringDown == true
				ring.position.y = (-modelParams.fontHeight/2 - modelParams.height * v*0.39)
			m = null
			for mesh in obj.children when mesh? and mesh.userData.meshUp == true
				mesh.scale.z = v*0.4
				m = mesh
			for ring in obj.children when ring? and ring.userData.ringUp == true
				ring.position.y = (modelParams.fontHeight/2 + modelParams.height * v*0.39)
		modelParams.heightv = v
		renderf()

	vLast = 0
	modelParams.changeThickness = (v) =>
		v = parseFloat v
		scene.children.last().remove x for x in scene.children.last().children[..]
		modelParams.thickness = v
		modelParams.fontThickness = v
		create(modelParams)
		createText(modelParams)
		modelParams.changeHeight modelParams.heightv
		renderf()

	modelParams.changeSideSmooth = (v) =>
		scene.children.last().remove x for x in scene.children.last().children[..] when not x.userData.text?
		modelParams.bottomSmooth = v
		create(modelParams)
		modelParams.changeHeight modelParams.heightv
		# createText(modelParams)
		renderf()

	modelParams.changeFontHeight = (v) =>
		scene.children.last().remove x for x in scene.children.last().children[..] when x.userData.text == true
		x.position.y = -v/2 for x in scene.children.last().children[..] when x.userData.meshDown == true
		x.position.y = v/2 for x in scene.children.last().children[..] when x.userData.meshUp == true
		x.position.y = -v/2 - modelParams.heightv for x in scene.children.last().children[..] when x.userData.ringDown == true
		x.position.y = v/2 + modelParams.heightv for x in scene.children.last().children[..] when x.userData.ringUp == true
		modelParams.fontHeight = v
		# create(modelParams)
		createText(modelParams)
		renderf()

	modelParams.changeFont = (currentStr, font) =>
		
		f = =>
			maxTextCount = Math.PI * config.p2.size / 4;

			a = parseInt(maxTextCount / currentStr.length);
			if (a && currentStr.length < 6) 
			    c = "";
			    for b in [0..a]
			        c += currentStr;
			        if (c.length > 5)
			            break
			    return c;
			return currentStr.substr(0, maxTextCount)

		currentStr = f()
		modelParams.font = font
		modelParams.changeText(currentStr, font)

	modelParams.changeText = (str) ->
		scene.children.last().remove x for x in scene.children.last().children[..] when x.userData.text == true
		modelParams.text = str
		# create(modelParams)
		createText(modelParams)
		renderf()

	modelParams.changeSize = (v) ->
		for ring in scene.children when ring? and ring.userData.model == true
			ring.scale.x = ring.scale.y = ring.scale.z = v*0.055

		renderf()

	modelParams.functionsTable["p-height"] = modelParams.changeHeight
	modelParams.functionsTable["p-thickness"] = modelParams.changeThickness
	modelParams.functionsTable["p-text-height"] = modelParams.changeFontHeight
	modelParams.functionsTable["p-side-smooth"] = modelParams.changeSideSmooth
	modelParams.functionsTable["p-selected-font"] = modelParams.changeFont
	modelParams.functionsTable["p-panel-text"] = modelParams.changeText
	modelParams.functionsTable["p-size"] = modelParams.changeSize
	
	
	if loadedModels.mring == null
		create(modelParams)
		modelParams.text = "MYOMYO"
		createText(modelParams)
		loadedModels.mring = combine.clone()
		combine.scale.x = combine.scale.y = combine.scale.z = config.p3.size*0.055
		scene.add combine 
	else
		combine = loadedModels.mring.clone()
		changeMaterialNew combine, modelParams.material
		combine.scale.x = combine.scale.y = combine.scale.z = config.p3.size*0.055
		scene.add combine

	$("#ajax-loading").hide()


class qtE extends THREE.Mesh
	constructor: (b, a) ->
		super
		@qab = b
		@text = new THREE.Object3D()
		@geometryTexts = []
		return  if a.qup is `undefined`
		@qiu()

		qrU = (c, a) ->
			for b of a
				c[b] = a[b]  if a[b] isnt `undefined`
			c

		qrU @options, a

		@flag_qqe = true
		return

	qtE::createTextGeometry = (d) ->
		c = new THREE.TextGeometry d, @options
		c.computeBoundingBox()
		c.computeVertexNormals()
		THREE.GeometryUtils.center c

		# qiW = (b, k, c) ->
		# 	a = b.qyb
		# 	c = Math.abs(0 - k.z)
		# 	g = 0 - k.z
		# 	for d of a
		# 		j = a[d]
		# 		f = j.x / c
		# 		h = c * Math.sin(f)
		# 		g = c * Math.cos(f)
		# 		e = (new THREE.Vector2(h, g)).normalize()
		# 		j.x = h + k.x + e.x * j.z
		# 		j.z = g + k.z + e.y * j.z
		# 	return
		qiW = (geometry, v3, c) ->
			vertList = geometry.vertices
			c = Math.abs 0 - v3.z
			g = 0 - v3.z
			for i, t of vertList
				vert = vertList[i]
				f = vert.x / c
				h = c * Math.sin(f)
				g = c * Math.cos(f)
				e = (new THREE.Vector2(h, g)).normalize()
				vert.x = h + v3.x + e.x * vert.z
				vert.z = g + v3.z + e.y * vert.z

		# qiW c, new THREE.Vector3(0, 0, -@options.quj)
		b = silverMaterial.clone()
		e = new THREE.Mesh(c, b)
		e

	qtE::qeg = (a) ->
		for b of a
			@options[b] = a[b]
		return

	qtE::qiu = ->
		@options =
			isSpaceFixed: false
			text: "FFFFFF"
			qrK: 30
			position: 0
			size: 0
			fontHeight: 2
			fontThickness: 1
			height: 0.4
			curveSegments: 4
			quj: 15.8
			font: "helvetiker"
			weight: "normal"
			style: "normal"
			bevelThickness: 0.01
			bevelSize: 0.1
			bevelSegments: 1
			bevelEnabled: true
			qrn: 1
			extrudeMaterial: 0

		return

	qtE::update = (a) ->
		if a.text isnt @options.text or a.font isnt @options.font
			@flag_qqe = true
		else
			@flag_qqe = false

		qrU = (c, a) ->
			for b of a
				c[b] = a[b]  if a[b] isnt `undefined`
			c

		qrU @options, a
		@create()
		return

	qtE::qau = ->
		a = @qab
		for b of @geometryTexts
			a.qaq @geometryTexts[b]
		@geometryTexts.length = 0
		@create()
		return

	qtE::create = ->
		j = @qab
		q = undefined

		# if @options.isSpaceFixed
			# q = 10 / @options.qrK
		# else
		q =  @options.text.length + 0.9
		q =  @options.text.length + 1.2 if  @options.text.length > 6
		q =  @options.text.length + 1.3 if  @options.text.length == 8
		q =  @options.text.length + 1.6 if  @options.text.length == 9
		q =  @options.text.length + 1.7 if  @options.text.length == 10
		q =  @options.text.length + 1.8 if  @options.text.length == 11
		q =  @options.text.length + 1.9 if  @options.text.length == 12
		# q =  @options.text.length + 2 if  @options.text.length == 9

		n = undefined
		f = []
		n = 0

		while n < q
			h = @options.position + n / q
			h -= 1  if h > 1
			f.push @options.qup.getPointAt(h)
			n++

		if @flag_qqe
			for a of @geometryTexts
				@text.remove @geometryTexts[a]
			@geometryTexts.length = 0

		k = 0
		for p of @options.text

			if @options.text[p] isnt " "
				t = undefined
				if @flag_qqe
					t = @createTextGeometry(@options.text[p])
					@geometryTexts.push t
					@text.add t
					t.qpm = true
				else
					t = @geometryTexts[k]
					k++

				t.position = f[p]

				r = new THREE.Vector3(0, 0, 1)
				h = @options.position + p / q
				h -= 1  if h > 1
				i = @options.qup.getTangentAt(h)
				s = i
				m = s.applyAxisAngle(new THREE.Vector3(0, 1, 0), -Math.PI / 2)
				l = r.angleTo(m)

				t.setRotationFromQuaternion new THREE.Quaternion()
				t.rotateY l
				t.rotateY (Math.PI - l) * 2  if m.x < 0
				g = t.geometry.boundingBox
				b = @options.fontHeight / (g.max.y - g.min.y)
				e = @options.fontThickness / (g.max.z - g.min.z)
				t.scale.set b, b, e


class qyt extends THREE.Geometry
	constructor: (b, a) ->
		super
		@__v1 = new THREE.Vector2
		@__v2 = new THREE.Vector2
		@__v3 = new THREE.Vector2
		@__v4 = new THREE.Vector2
		@__v5 = new THREE.Vector2
		@__v6 = new THREE.Vector2
		@qiu a
		@addShape b
		# quQ = ->
		# 	c = undefined
		# 	b = undefined
		# 	a = undefined
		# 	c = 0
		# 	b = @faces.length

		# 	while c < b
		# 		a = @faces[c]
		# 		a.qpS.set 0, 0, 0
		# 		a.qpS.add @qyb[a.a]
		# 		a.qpS.add @qyb[a.b]
		# 		a.qpS.add @qyb[a.c]
		# 		a.qpS.divideScalar 3
		# 		c++
		# 	return
	 #  	quQ
		@computeFaceNormals()
		@computeVertexNormals()

qyt::addShapeList = (b, c) ->
	a = b.length
	d = 0

	while d < a
			e = b[d]
			@addShape e, c
			d++
	return

qyt::qiu = (a) ->
	c = {}
	c.amount = 1.5
	c.curveSegments = 30
	c.bevelEnabled = true
	c.bevelSegments = 5
	c.steps = 1
	c.holeBevelSize = 0.1
	c.bevelSize = 0.1
	c.bevelThickness = 0.1
	c.frontContourBevelSize = 0.1
	c.frontContourBevelThickness = 0.1
	c.backContourBevelSize = 0.1
	c.backContourBevelThickness = 0.1
	c.frontHoleBevelSize = 0.1
	c.frontHoleBevelThickness = 0.1
	c.backHoleBevelSize = 0.1
	c.backHoleBevelThickness = 0.1
	c.innerRadius = 14
	c.outerRadius = 15
	c.height = 2
	c.thickness = 1
	for b of a
			c[b] = a[b]
	@options = c
	return

qyt::addShape = (aF) ->
	aD = (i, h, b) ->
		console.log "die"  unless h
		h.clone().multiplyScalar(b).add i
	aE = (i, h, b) ->
		d i, h, b
	f = (j, i, h) ->
		t = Math.atan2(i.y - j.y, i.x - j.x)
		s = Math.atan2(h.y - j.y, h.x - j.x)
		s += Math.PI * 2  if t > s
		k = (t + s) / 2
		aM = -Math.cos(k)
		v = -Math.sin(k)
		b = new THREE.Vector2(aM, v)
		b
	d = (aN, aM, t) =>
		aS = @__v1
		aP = @__v2
		aR = @__v3
		aO = @__v4
		j = @__v5
		i = @__v6
		aU = undefined
		aT = undefined
		k = undefined
		aQ = undefined
		aV = undefined
		h = undefined
		aS.set aN.x - aM.x, aN.y - aM.y
		aP.set aN.x - t.x, aN.y - t.y
		aU = aS.normalize()
		aT = aP.normalize()
		aR.set -aU.y, aU.x
		aO.set aT.y, -aT.x
		j.copy(aN).add aR
		i.copy(aN).add aO
		return aO.clone()  if j.equals(i)
		j.copy(aM).add aR
		i.copy(t).add aO
		k = aU.dot(aO)
		aQ = i.sub(j).dot(aO)
		if k is 0
				console.log "Either infinite or no solutions!"
				if aQ is 0
						console.log "Its finite solutions."
				else
						console.log "Too bad, no solutions."
		aV = aQ / k
		return f(aN, aM, t)  if aV < 0
		h = aU.multiplyScalar(aV).add(j)
		h.sub(aN).clone()
	ac = ->
		if B
				j = 0
				b = at * j
				h = 0

				while h < F
						c = aK[h]
						p c[2] + b, c[1] + b, c[0] + b, true
						h++
				j = R + C * 2
				b = at * j
				h = 0

				while h < F
						c = aK[h]
						p c[0] + b, c[1] + b, c[2] + b, false
						h++
		else
				h = 0

				while h < F
						c = aK[h]
						p c[2], c[1], c[0], true
						h++
				h = 0

				while h < F
						c = aK[h]
						p c[0] + at * R, c[1] + at * R, c[2] + at * R, false
						h++
		return
	aw = ->
		i = 0
		K aB, i
		i += aB.length
		j = 0
		b = aH.length

		while j < b
				aG = aH[j]
				K aG, i
				i += aG.length
				j++
		return
	K = (aO, h) ->
		aM = undefined
		v = undefined
		V = aO.length
		while --V >= 0
				aM = V
				v = V - 1
				v = aO.length - 1  if v < 0
				aT = 0
				i = R + C * 2
				aT = 0
				while aT < i
						aN = at * aT
						t = at * (aT + 1)
						aS = h + aM + aN
						aR = h + v + aN
						aQ = h + v + t
						aP = h + aM + t
						o aS, aR, aQ, aP, aO, aT, i, aM, v
						aT++
		return
	N = (b, i, h) ->
		av.vertices.push new THREE.Vector3(b, i, h)
		return
	p = (i, h, s, k) ->
		i += n
		h += n
		s += n
		av.faces.push new THREE.Face3(i, h, s, null, null, M)
		j = (if k then aC.generateBottomUV(av, aF, an, i, h, s) else aC.generateTopUV(av, aF, an, i, h, s))
		av.faceVertexUvs[0].push j
		return
	o = (aN, aM, t, s, h, j, aO, v, k) ->
		aN += n
		aM += n
		t += n
		s += n
		av.faces.push new THREE.Face3(aN, aM, s, null, null, l)
		av.faces.push new THREE.Face3(aM, t, s, null, null, l)
		i = aC.generateSideWallUV(av, aF, h, an, aN, aM, t, s, j, aO, v, k)
		av.faceVertexUvs[0].push [
				i[0]
				i[1]
				i[3]
		]
		av.faceVertexUvs[0].push [
				i[1]
				i[2]
				i[3]
		]
		return

	an = @options
	ad = an.bevelThickness
	aI = an.bevelSize
	C = an.bevelSegments
	a = an.frontContourBevelSize
	ae = an.backContourBevelSize
	I = an.frontHoleBevelSize
	ai = an.backHoleBevelSize
	af = an.frontContourBevelThickness
	ao = an.backContourBevelThickness
	U = an.frontHoleBevelThickness
	aJ = an.backHoleBevelThickness
	am = Math.max(I, ai)
	au = Math.max(a, ae)
	J = an.amount
	@qup = aF
	B = an.bevelEnabled
	ar = an.curveSegments
	R = an.steps
	u = an.extrudePath
	al = undefined
	q = false
	M = an.qrn
	l = an.extrudeMaterial
	aC = (if an.UVGenerator isnt `undefined` then an.UVGenerator else WorldUVGenerator)
	@shapebb = aF.getBoundingBox()
	aA = @shapebb
	r = undefined
	Y = undefined
	ab = undefined
	X = undefined
	if u
			al = u.qef(R)
			q = true
			B = false
			r = (if an.frames isnt `undefined` then an.frames else new qom.qqx.FrenetFrames(u, R, false))
			console.log r, "splineTube", r.qok.length, "steps", R, "extrudePts", al.length
			Y = new THREE.Vector3()
			ab = new THREE.Vector3()
			X = new THREE.Vector3()
			console.log al
	unless B
			C = 0
			ad = 0
			aI = 0
	aG = undefined
	W = undefined
	aj = undefined
	av = this
	aq = []
	n = @vertices.length
	ah = aF.extractPoints(ar)
	D = ah.shape
	aH = ah.holes
	e = not THREE.Shape.Utils.isClockWise(D)
	if e
			D = D.reverse()
			W = 0
			aj = aH.length

			while W < aj
					aG = aH[W]
					aH[W] = aG.reverse()  if THREE.Shape.Utils.isClockWise(aG)
					W++
			e = false
	aK = THREE.Shape.Utils.triangulateShape(D, aH)
	debug aK
	aB = D
	W = 0
	aj = aH.length

	while W < aj
			aG = aH[W]
			D = D.concat(aG)
			W++
	Z = undefined
	aa = undefined
	O = undefined
	L = undefined
	az = undefined
	at = D.length
	c = undefined
	F = aK.length
	ap = undefined
	A = aB.length
	debug at, F, A
	ag = 180 / Math.PI
	ak = []
	V = 0
	P = aB.length
	T = P - 1
	S = V + 1

	while V < P
			T = 0  if T is P
			S = 0  if S is P
			H = aB[V]
			G = aB[T]
			E = aB[S]
			ak[V] = aE(aB[V], aB[T], aB[S])
			T++
			S++
			V++
	ax = []
	g = undefined
	aL = ak.concat()
	W = 0
	aj = aH.length

	while W < aj
			aG = aH[W]
			g = []
			V = 0
			P = aG.length
			T = P - 1
			S = V + 1

			while V < P
					T = 0  if T is P
					S = 0  if S is P
					g[V] = aE(aG[V], aG[T], aG[S])
					T++
					S++
					V++
			ax.push g
			aL = aL.concat(g)
			W++
	Z = 0

	while Z < C
			O = Z / C
			V = 0
			P = aB.length

			while V < P
					aa = ae * (Math.sin(O * Math.PI / 2))
					ay = aB[V]
					ay = aD(ay, ak[V], a - ae)  if a > ae
					az = aD(ay, ak[V], aa)
					L = -ao * (Math.sin((1 - O) * Math.PI / 2))
					L -= aJ - ao  if ao < aJ
					N az.x, az.y, L
					V++
			W = 0
			aj = aH.length

			while W < aj
					aa = ai * (Math.sin(O * Math.PI / 2))
					aG = aH[W]
					g = ax[W]
					V = 0
					P = aG.length

					while V < P
							m = aG[V]
							m = aD(m, g[V], I - ai)  if I > ai
							az = aD(m, g[V], aa)
							L = -aJ * (Math.sin((1 - O) * Math.PI / 2))
							L -= ao - aJ  if ao > aJ
							N az.x, az.y, L
							V++
					W++
			Z++
	V = 0

	while V < at
			if V < at / 2
					aa = Math.max(a, ae)
			else
					aa = Math.max(I, ai)
			az = (if B then aD(D[V], aL[V], aa) else D[V])
			unless q
					N az.x, az.y, 0
			else
					ab.copy(r.qok[0]).multiplyScalar az.x
					Y.copy(r.binormals[0]).multiplyScalar az.y
					X.copy(al[0]).add(ab).add Y
					N X.x, X.y, X.z
			V++
	Q = undefined
	Q = 1
	while Q <= R
			V = 0
			while V < at
					if V < at / 2
							aa = Math.max(a, ae)
					else
							aa = Math.max(I, ai)
					az = (if B then aD(D[V], aL[V], aa) else D[V])
					unless q
							N az.x, az.y, J / R * Q
					else
							ab.copy(r.qok[Q]).multiplyScalar az.x
							Y.copy(r.binormals[Q]).multiplyScalar az.y
							X.copy(al[Q]).add(ab).add Y
							N X.x, X.y, X.z
					V++
			Q++
	Z = C - 1

	while Z >= 0
			O = Z / C
			V = 0
			P = aB.length

			while V < P
					aa = a * (Math.sin(O * Math.PI / 2))
					ay = aB[V]
					ay = aD(ay, ak[V], ae - a)  if a < ae
					az = aD(ay, ak[V], aa)
					L = af * (Math.sin((1 - O) * Math.PI / 2))
					L += U - af  if af < U
					N az.x, az.y, J + L
					V++
			aa = am * Math.sin(O * Math.PI / 2)
			W = 0
			aj = aH.length

			while W < aj
					aa = I * (Math.sin(O * Math.PI / 2))
					aG = aH[W]
					g = ax[W]
					V = 0
					P = aG.length

					while V < P
							m = aG[V]
							m = aD(m, g[V], ai - I)  if I < ai
							az = aD(m, g[V], aa)
							L = U * (Math.sin((1 - O) * Math.PI / 2))
							L += af - U  if af > U
							unless q
									N az.x, az.y, J + L
							else
									N az.x, az.y + al[R - 1].y, al[R - 1].x + L
							V++
					W++
			Z--
	ac()
	aw()
	return

debug = ->
	# a = arguments_.length
	return

WorldUVGenerator =
	generateTopUV: (b, h, e, k, j, i) ->
		a = b.vertices[k].x
		l = b.vertices[k].y
		g = b.vertices[j].x
		f = b.vertices[j].y
		d = b.vertices[i].x
		c = b.vertices[i].y
		[
				new THREE.Vector2(a, l)
				new THREE.Vector2(g, f)
				new THREE.Vector2(d, c)
		]

	generateBottomUV: (f, c, a, e, d, b) ->
		@generateTopUV f, c, a, e, d, b

	generateSideWallUV: (m, l, b, t, B, A, v, u, a, n, s, r) ->
		j = m.vertices[B].x
		h = m.vertices[B].y
		f = m.vertices[B].z
		q = m.vertices[A].x
		p = m.vertices[A].y
		o = m.vertices[A].z
		e = m.vertices[v].x
		d = m.vertices[v].y
		c = m.vertices[v].z
		k = m.vertices[u].x
		i = m.vertices[u].y
		g = m.vertices[u].z
		if Math.abs(h - p) < 0.01
				[
						new THREE.Vector2(j, 1 - f)
						new THREE.Vector2(q, 1 - o)
						new THREE.Vector2(e, 1 - c)
						new THREE.Vector2(k, 1 - g)
				]
		else
				[
						new THREE.Vector2(h, 1 - f)
						new THREE.Vector2(p, 1 - o)
						new THREE.Vector2(d, 1 - c)
						new THREE.Vector2(i, 1 - g)
				]