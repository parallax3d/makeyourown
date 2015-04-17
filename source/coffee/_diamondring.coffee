DiamondRing = (callback) ->

	do addRotateModelHandlers

	[controls.minPolarAngle, controls.maxPolarAngle] = [0, Math.PI]		
	controls.minDistance = 40
	controls.maxDistance = 68
	# camera.position = new THREE.Vector3
	controls.center = new THREE.Vector3

	camera.position.z = 60
	camera.position.y = 55
	camera.position.x = 0

	combine = new THREE.Object3D	

	manager = new THREE.LoadingManager
	loader = new THREE.OBJLoader manager 

	if loadedModels.diamondRing == null
		$("#ajax-loading").show()
		loadedModels.diamondRing = {}
		
		example "obj/diamond/backend/ring1.obj", (object) ->

			object.traverse (child) ->
				if child instanceof THREE.Mesh
					child.material = silverMaterial.clone()
		
			object.position.y = 10
			object.scale.x = object.scale.z = object.scale.y = config.p1.size*0.08*0.08115
			object.geometry.applyMatrix new THREE.Matrix4().makeTranslation(0, -100, 0)
			object.userData.ring = true

			# combine.scale.x = combine.scale.y = combine.scale.z = 6.0;
			combine.add object 

			loadedModels.diamondRing = combine.clone()

			$("#ajax-loading").hide()
			renderf()

		example "obj/diamond/backend/diamond1.obj", (object) ->

			object.traverse (child) ->
				if child instanceof THREE.Mesh
					child.material = silverMaterial.clone()

			object.position.y = 9.5
			object.userData.diamond = true
			object.geometry.applyMatrix new THREE.Matrix4().makeTranslation(0, 88, 0)
			object.scale.x = object.scale.z = object.scale.y = config.p1.sizeDiamond*0.075*0.07
			combine.add object 

			loadedModels.diamondRing = combine.clone()

			$("#ajax-loading").hide()
			renderf()

		combine.userData.model = true
		combine.position.y = 0

		scene.add combine
	else
		combine = loadedModels.diamondRing
		changeMaterialNew combine, modelParams.material
		scene.add combine

	modelParams.n = 1

	modelParams.changeSizeDiamond = (v) ->
		modelParams.sizeDiamond = v*0.05
		for obj in scene.children when obj? and obj.userData.model == true
			for dia in obj.children when dia.userData.diamond == true
				mod = if modelParams.n >= 2 and modelParams.n <= 5 then 0.8 else 1
				# mod = if modelParams.n == 1  then 1 else 1
				dia.scale.x = dia.scale.y = dia.scale.z = v * mod * 0.075 * 0.07
		modelParams.price()
		renderf()

	modelParams.changeDiamondModel = (n, size) ->
		n = parseInt n
		modelParams.n = n
		$("#ajax-loading").show()

		model = null
		for obj in scene.children when obj.userData.model == true
			for dia in obj.children when dia? and dia.userData.diamond == true
				obj.remove dia
			model = obj

		example "obj/diamond/backend/diamond" + n + ".obj", (object) ->

			object.traverse (child) ->
				if child instanceof THREE.Mesh
					child.material = silverMaterial.clone()
					changeMeshMaterial child, modelParams.material

			object.position.y = 9.5
			object.userData.diamond = true
			mod = if n >= 2 and n <= 5 then 0.8 else 1
			# mod = if n == 1 then 1 else 1
			down = switch n
					   when 6
					       30
					   when 5
					   	   10
					   when 4
					   	   10
					   else
					   		0

			object.geometry.applyMatrix new THREE.Matrix4().makeTranslation(0, 88 - down, 0)
			object.scale.x = object.scale.z = object.scale.y = modelParams.sizeDiamond * mod * 0.075*0.07

			model.add object 

			modelParams.changeSizeDiamond size if size?

			$("#ajax-loading").hide()
			renderf()


		renderf()
		# modelParams.price()

	modelParams.changeRingModel = (n) ->
		$("#ajax-loading").show()

		model = null
		for obj in scene.children when obj.userData.model == true
			for ring in obj.children when ring? and ring.userData.ring == true
				obj.remove ring
			model = obj

		loader = new THREE.OBJLoader manager 
		example "obj/diamond/backend/ring" + n + ".obj", (object) ->

			object.traverse (child) ->
				if child instanceof THREE.Mesh
					child.material = silverMaterial.clone()
					changeMeshMaterial child, modelParams.material


			object.position.y = 10
			object.userData.ring = true
			object.scale.x = object.scale.z = object.scale.y = modelParams.size*0.08*0.08115
			object.geometry.applyMatrix new THREE.Matrix4().makeTranslation(0, -100, 0)

			model.add object 

			$("#ajax-loading").hide()
			renderf()

		# modelParams.price()
		renderf()	
	modelParams.changeSize = (v) ->
		modelParams.size = v
		for obj in scene.children when obj? and obj.userData.model == true
			for ring in obj.children when ring.userData.ring == true
				ring.scale.x = ring.scale.y = ring.scale.z = v*0.08*0.08115
		modelParams.price()
		renderf()

	modelParams.functionsTable["p-ring-diamond"] = modelParams.changeDiamondModel
	modelParams.functionsTable["p-ring"] = modelParams.changeRingModel
	modelParams.functionsTable["p-size-diamond"] = modelParams.changeSizeDiamond
	modelParams.functionsTable["p-size"] = modelParams.changeSize

	modelParams.functionsTable["p-selected-font"] = modelParams.changeFont
	modelParams.functionsTable["p-panel-text"] = modelParams.changeText

readObj = (oFile, vs, fs) ->
  l = oFile.split(/[\r\n]/g)
  i = 0

  while i < l.length
    ls = l[i].trim().split(/\s+/)
    if ls[0] is "v"
      v = new THREE.Vector3(parseFloat(ls[1]) * 100, parseFloat(ls[2]) * 100, parseFloat(ls[3]) * 100)
      vs.push v
    if ls[0] is "f"
      f = new THREE.Face3(parseFloat(ls[1]) - 1, parseFloat(ls[2]) - 1, parseFloat(ls[3]) - 1)
      fs.push f
    i++
  return
readAsciiStl = (l, vs, fs) ->
  solid = false
  face = false
  vis = []
  vtest = {}
  i = 0

  while i < l.length
    line = l[i]
    if solid
      if line.search("endsolid") > -1
        solid = false
      else if face
        if line.search("endfacet") > -1
          face = false
          f = new THREE.Face3(vis[0], vis[1], vis[2])
          fs.push f
        else if line.search("vertex") > -1
          cs = line.substr(line.search("vertex") + 7)
          cs = cs.trim()
          ls = cs.split(/\s+/)
          v = new THREE.Vector3(parseFloat(ls[0]), parseFloat(ls[1]), parseFloat(ls[2]))
          vi = vs.length
          if cs of vtest
            vi = vtest[cs]
          else
            vs.push v
            vtest[cs] = vi
          vis.push vi
      else
        if line.search("facet normal") > -1
          face = true
          vis = []
    else
      solid = true  if line.search("solid") > -1
    i++
  vtest = null
  return
triangle = ->
  if arguments.length is 2
    @_buffer = arguments[0]
    @_sa = arguments[1]
  else
    @_sa = 0
    @_buffer = new ArrayBuffer(50)
  @__byte = new Uint8Array(@_buffer)
  @normal = new Float32Array(@_buffer, @_sa + 0, 3)
  @v1 = new Float32Array(@_buffer, @_sa + 12, 3)
  @v2 = new Float32Array(@_buffer, @_sa + 24, 3)
  @v3 = new Float32Array(@_buffer, @_sa + 36, 3)
  _attr = new Int16Array(@_buffer, @_sa + 48, 1)
  Object.defineProperty this, "attr",
    get: ->
      _attr[0]

    set: (val) ->
      _attr[0] = val
      return

    enumerable: true

  return
readBinaryStl = (l, vs, fs) ->
  buf = new ArrayBuffer(l.length)
  bbuf = new Uint8Array(buf)
  i = 0

  while i < l.length
    bbuf[i] = l.charCodeAt(i)
    i++
  trnr = new Uint32Array(buf, 80, 1)
  vis = [
    0
    0
    0
  ]
  vtest = {}
  offset = 84
  face = new triangle()
  i = 0
  while i < trnr[0]
    j = 0

    while j < 50
      face.__byte[j] = bbuf[offset + j]
      j++
    v = new THREE.Vector3(face.v1[0], face.v1[1], face.v1[2])
    k = "" + face.v1[0] + "," + face.v1[1] + "," + face.v1[2]
    vis[0] = vs.length
    if k of vtest
      vis[0] = vtest[k]
    else
      vs.push v
      vtest[k] = vis[0]
    v = new THREE.Vector3(face.v2[0], face.v2[1], face.v2[2])
    k = "" + face.v2[0] + "," + face.v2[1] + "," + face.v2[2]
    vis[1] = vs.length
    if k of vtest
      vis[1] = vtest[k]
    else
      vs.push v
      vtest[k] = vis[1]
    v = new THREE.Vector3(face.v3[0], face.v3[1], face.v3[2])
    k = "" + face.v3[0] + "," + face.v3[1] + "," + face.v3[2]
    vis[2] = vs.length
    if k of vtest
      vis[2] = vtest[k]
    else
      vs.push v
      vtest[k] = vis[2]
    normal = new THREE.Vector3(face.normal[0], face.normal[1], face.normal[2])
    f = new THREE.Face3(vis[0], vis[1], vis[2], normal)
    fs.push f
    offset += 50
    i++
  vtest = null
  bbuf = `undefined`
  buf = null
  return
readStl = (oFile, vs, fs) ->
  if oFile instanceof ArrayBuffer
    return arrayBufferToBinaryString(oFile, (stl) ->
      readBinaryStl stl, vs, fs
      return
    )
  solididx = oFile.search("solid")
  if solididx > -1 and solididx < 10
    l = oFile.split(/[\r\n]/g)
    readAsciiStl l, vs, fs
  else
    readBinaryStl oFile, vs, fs
  return
buildGeometry = (l, f) ->
  vs = []
  fs = []
  if f.name.indexOf(".obj") > -1
    readObj l, vs, fs
  else if f.name.indexOf(".stl") > -1
    readStl l, vs, fs
  else
    return
  for i of fs
    if i != "last"
      v0 = vs[fs[i].a]
      v1 = vs[fs[i].b]
      v2 = vs[fs[i].c]
      e1 = new THREE.Vector3(v1.x - v0.x, v1.y - v0.y, v1.z - v0.z)
      e2 = new THREE.Vector3(v2.x - v0.x, v2.y - v0.y, v2.z - v0.z)
      n = new THREE.Vector3(e1.y * e2.z - e1.z * e2.y, e1.z * e2.x - e1.x * e2.z, e1.x * e2.y - e1.y * e2.x)
      l = Math.sqrt(n.x * n.x + n.y * n.y + n.z * n.z)
      n.x /= l
      n.y /= l
      n.z /= l
      fs[i].normal = n
  mx = 1e10
  my = 1e10
  mz = 1e10
  Mx = -1e10
  My = -1e10
  Mz = -1e10
  for i of vs
    mx = vs[i].x  if mx > vs[i].x
    my = vs[i].y  if my > vs[i].y
    mz = vs[i].z  if mz > vs[i].z
    Mx = vs[i].x  if Mx < vs[i].x
    My = vs[i].y  if My < vs[i].y
    Mz = vs[i].z  if Mz < vs[i].z
  max = Math.max(Mx - mx, My - my, Mz - mz)
  max /= 200
  cx = (Mx + mx) / 2
  cy = (My + my) / 2
  cz = (Mz + mz) / 2
  for i of vs
    vs[i].x -= cx
    vs[i].y -= cy
    vs[i].z -= cz
    vs[i].x /= max
    vs[i].y /= max
    vs[i].z /= max
  mx = 1e10
  my = 1e10
  mz = 1e10

  Mx = -1e10
  My = -1e10
  Mz = -1e10

  for i of vs
    mx = vs[i].x  if mx > vs[i].x
    my = vs[i].y  if my > vs[i].y
    mz = vs[i].z  if mz > vs[i].z
    Mx = vs[i].x  if Mx < vs[i].x
    My = vs[i].y  if My < vs[i].y
    Mz = vs[i].z  if Mz < vs[i].z
  geometry = new THREE.Geometry()
  geometry.vertices = vs
  geometry.faces = fs
  # geometry.computeFaceNormals()
  # geometry.computeVertexNormals()
  # scene.remove mesh  if mesh
  mesh = new THREE.Mesh geometry, silverMaterial.clone()
  # scene.add mesh
  # render()
  return mesh
handleFiles = (f) ->
  reader = new FileReader()
  reader.onload = (e) ->
    oFile = e.target.result
    buildGeometry oFile, f[0]
    return

  file = f[0]
  reader.readAsBinaryString file
  return

example = (file, onload) ->
  xhr = new XMLHttpRequest()
  xhr.open "GET", file, true
  xhr.onload = ->
    oFile = @response
    f = {}
    f.name = file
    onload buildGeometry oFile, f
    return

  xhr.send ""
  return