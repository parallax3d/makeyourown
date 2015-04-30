NecklaceText = (options) ->
	{font, str, radius, size, rotation, diagonal} = options

	size = size or= 5.4
	diagonal = diagonal or=false
	rotation = rotation or=0
	height = 0.001

	geom = new THREE.Geometry

	textWidth = 0

	raycaster = new THREE.Raycaster()

	_oldInt = 0
	y = 0
	intersectGeometry = (textGeometry, index) ->
		geom.computeBoundingBox()
		textGeometry.computeBoundingBox()

		obj1x = geom.boundingBox.max.x
		if(geom.vertices.length == 0)
			obj1x = 0

		height = textGeometry.boundingBox.max.y - textGeometry.boundingBox.min.y

		leftBorder = 1.0
		rightBorder = 0.5

		# left to right
		tObj2 = new THREE.Mesh textGeometry

		z = 0
		if(str.length == 1)
			y = 0
		else if(diagonal)
			if(index == 0)
				y = 0.5
			else
				y = -0.5
				z =	0.5

		mergeDistance = 1
		if(diagonal)
			mergeDistance = 0.8

		textGeometry.applyMatrix new THREE.Matrix4().makeTranslation (obj1x - _oldInt) * mergeDistance, y, z

		#  right to left
		origin1 = new THREE.Vector3( textGeometry.boundingBox.max.x, rightBorder + y, z)
		direction1=  new THREE.Vector3(-1,0,0)
		raycaster.set( origin1, direction1 )
		intersects1 = raycaster.intersectObject( tObj2 )
		_oldInt = intersects1[0].distance

		geom.merge textGeometry
		geom.computeBoundingBox()
		textWidth = geom.boundingBox.max.x - geom.boundingBox.min.x - _oldInt

	for lt, i in str.split ""
		options.lt = lt
		geometry = NeklaceSymbol options
		intersectGeometry geometry, i

	obj = new THREE.Mesh geom, silverMaterial.clone()

	obj.textWidth = textWidth
	obj.nowText = str

	textRotation = (geometry, v3, c) ->
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

	if rotation != 0
		textRotation geom, new THREE.Vector3(0, 0, -1 * rotation)

	return obj

NeklaceSymbol = (options) ->
	{font, lt, radius, size, index} = options
	size = size or= 5.4
	height = 0.001

	unless (/[a-zmaxTextLengthA-Zа-яА-Я0-9]/g).test(lt)
		font = 'icomoon'
		size *= 2.0

	textGeom = new THREE.TextGeometry lt, { font: font.toLowerCase(), size: size, height: height, curveSegments: 10,	bevelEnabled: true, bevelThickness: 0.3, bevelSize: 0.2,}

	return textGeom
