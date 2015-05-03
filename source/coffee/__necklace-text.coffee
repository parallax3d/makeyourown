NecklaceText = (options) ->
	{font, str, radius, size, rotation, diagonal} = options

	size = size or= 5.4
	diagonal = diagonal or=false
	rotation = rotation or=0
	height = 0.001

	# create a main obj
	geom = new THREE.Geometry
	obj = new THREE.Mesh geom, silverMaterial.clone()
	# Store all information regaring symbols and its intersection
	obj.userData.symbols = []

	textWidth = 0

	raycaster = new THREE.Raycaster()
	intersect = (obj, x, y, z, direction) ->
		origin = new THREE.Vector3( x, y, z)
		raycaster.set( origin, direction )
		intersects = raycaster.intersectObject( obj )
		return if intersects[0] then intersects[0].distance else 0

	intersectGeometry = (textGeometry, index) ->

		userData = obj.userData.symbols[index]

		geom.computeBoundingBox()
		textGeometry.computeBoundingBox()

		obj1x = geom.boundingBox.max.x
		if(geom.vertices.length == 0)
			obj1x = 0

		leftBorder = 1.0
		rightBorder = 0.5

		z = 0
		y = 0
		if(str.length == 1)
			y = 0
		else if(diagonal)
			if(index == 0)
				y = 0.5
			else
				y = -0.5
				z =	0.5

		mergeDistance = 0
		if(diagonal)
			mergeDistance = -2

		userData.object = new THREE.Mesh textGeometry.clone()

		userData.maxX = textGeometry.boundingBox.max.x
		userData.minX = textGeometry.boundingBox.min.x
		userData.boxWidth = userData.maxX - userData.minX

		#  right to left
		userData.leftToRight = intersect(userData.object, userData.minX, leftBorder, 0, new THREE.Vector3(1,0,0))
		#  right to left
		userData.rightToLeft = intersect(userData.object, userData.maxX, rightBorder, 0, new THREE.Vector3(-1,0,0))
		userData.preTranslateX = 0 - userData.minX - userData.leftToRight

		userData.width = userData.boxWidth - userData.leftToRight - userData.rightToLeft

		if(index == 0)
			userData.translateX = userData.preTranslateX + mergeDistance
		else
			userData.translateX = obj1x - userData.preTranslateX - obj.userData.symbols[index - 1].rightToLeft + mergeDistance

		userData.translateY = y
		userData.translateZ = z
		textGeometry.applyMatrix new THREE.Matrix4().makeTranslation userData.translateX, userData.translateY, userData.translateZ

		geom.merge textGeometry
		geom.computeBoundingBox()
		textWidth = geom.boundingBox.max.x - geom.boundingBox.min.x

	# Text transformation
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

	# Loop for each word
	for lt, i in str.split ""
		obj.userData.symbols[i] =
			index: i
			symbol: lt
			rightToLeft: 0
			leftToRight: 0

		options.lt = lt
		geometry = NeklaceSymbol options
		intersectGeometry geometry, i

	if rotation != 0
		textRotation geom, new THREE.Vector3(0, 0, -1 * rotation)

	obj.textWidth = textWidth
	obj.nowText = str

	console.log obj.userData
	return obj

NeklaceSymbol = (options) ->
	{font, lt, size} = options
	size = size or= 5.4
	height = 0.001

	unless (/[a-zmaxTextLengthA-Zа-яА-Я0-9]/g).test(lt)
		font = 'icomoon'
		size *= 2.0

	textGeom = new THREE.TextGeometry lt, { font: font.toLowerCase(), size: size, height: height, curveSegments: 10,	bevelEnabled: true, bevelThickness: 0.3, bevelSize: 0.2,}

	return textGeom
