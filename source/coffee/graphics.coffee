render = null
scene = null
camera = null
manager = null
controls = null
silverMaterial = null
testMaterial = null

_global =
	rotate: true
	drift: true
	driftMax: 0.04
	driftSign: 1
	driftStep: 0.00003
	driftSmooth: 0.00006

loader = null

initGraphics = ->

	render = new THREE.WebGLRenderer { antialias:true, alpha: true }

	render.setSize size.width, size.height
	render.setClearColor 0xeeeeee

	$("#cont").append render.domElement

	camera = new THREE.PerspectiveCamera 70, size.width / size.height, 1, 1000
	camera.position.z = 100
	camera.position.y = 80

	controls = new THREE.OrbitControls camera, $("#cont")[0]
	[controls.noZoom, controls.noPan] = [false, true]
	controls.rotateSpeed = 0.5
	[controls.maxDistance, controls.minDistance] = [38, 18]
	[controls.minPolarAngle, controls.maxPolarAngle] = [0, Math.PI]

	controls.addEventListener 'change', renderf 

	$("#cont").on "mouseout", ->
		controls.stop()

	manager = new THREE.LoadingManager

	loader = new THREE.OBJLoader manager 

	scene = new THREE.Scene

	ambientLight = new THREE.AmbientLight 0x888888
	scene.add ambientLight

	directionalLight = new THREE.DirectionalLight 0xffffff
	directionalLight.position
		.set 1, 1, 1
		.normalize()

	scene.add directionalLight
	lastTime = 0

	createMaterial()

	animate = ->
		requestAnimationFrame animate

		dt = new Date().getTime() - lastTime
		lastTime = new Date().getTime()

		controls.update()

		if _global.rotate
			scene.children.last().rotation.y += 0.0005 * dt
			renderf()

		if _global.drift
			obj = scene.children.last()
			obj.rotation.z += _global.driftStep * _global.driftSign * dt
			if obj.rotation.z > _global.driftMax
				obj.rotation.z = _global.driftMax
				_global.driftSign = -1
			if obj.rotation.z < -_global.driftMax
				obj.rotation.z = -_global.driftMax
				_global.driftSign = 1

			renderf()

	animate()

renderf = ->
	render.render scene, camera

changeMeshMaterial = (mesh, type) ->
	if mesh instanceof THREE.Mesh
		if type == "gold" 
			mesh.material.specular.setHex 0xaa5500
			mesh.material.color.setHex 0xaa5500
			mesh.material.emissive.setHex 0xaaaa44
		else if type == "whiteGold"
			mesh.material.specular.setHex 0xffffff
			mesh.material.color.setHex 0xfefcff
			mesh.material.emissive.setHex 0xaaaaaa
		else if type == "silver"
			mesh.material.specular.setHex 0xffffff
			mesh.material.color.setHex 0xaaaaaa
			mesh.material.emissive.setHex 0x555555

changeMaterialNew = (obj, type) ->
	for child in obj.children
		changeMeshMaterial child, type
		changeMaterialNew child, type
	renderf()

createMaterial = (type) ->
	urls = 
	[ 
		"im/px.jpg", 
		"im/nx.jpg",
		"im/py.jpg", 
		"im/ny.jpg",	
		"im/pz.jpg", 
		"im/nz.jpg" 
	]

	envMap = THREE.ImageUtils.loadTextureCube urls
	envMap.format = THREE.RGBFormat

	silverMaterial = new THREE.MeshPhongMaterial
		# light
		specular: 0xffffff
		# intermediate
		color: 0xaaaaaa
		# dark
		emissive: 0x555555
		envMap: envMap
		shininess: 100

	testMaterial = new THREE.MeshPhongMaterial
			# light
			specular: 0xff0000
		# intermediate
			color: 0xff0000
		# dark
			emissive: 0x555555
			envMap: envMap
			shininess: 100

addRotateModelHandlers = ->
	do removeDriftModelHandlers

	_global.rotate = true
	controls.addEventListener 'start', rotateModelStartHandler, false
	controls.addEventListener 'end', rotateModelEndHandler, false

removeRotateModelHandlers = ->
	clearTimeout _global.drifttimeout
	clearTimeout _global.timeout
	_global.rotate = false
	controls.removeEventListener 'start', rotateModelStartHandler, false
	controls.removeEventListener 'end', rotateModelEndHandler, false

rotateModelStartHandler = -> 
	clearTimeout _global.timeout
	_global.rotate = false

rotateModelEndHandler = -> _global.timeout = setTimeout (-> _global.rotate = true unless _global.drift ), 4000

driftModelStartHandler = -> 
	clearTimeout _global.drifttimeout
	_global.drift = false
	_global.rotate = false

driftModelEndHandler = -> 
	_global.drifttimeout = setTimeout -> 
		_global.drift = true
		_global.rotate = false
	, 
		100

removeDriftModelHandlers = ->
	clearTimeout _global.drifttimeout
	clearTimeout _global.timeout
	_global.drift = false
	controls.removeEventListener 'start', driftModelStartHandler, false
	controls.removeEventListener 'end', driftModelEndHandler, false

addDriftModelHandlers = ->
	do removeRotateModelHandlers
	_global.drift = true
	_global.rotate = false
	controls.addEventListener 'start', driftModelStartHandler, false
	controls.addEventListener 'end', driftModelEndHandler, false
