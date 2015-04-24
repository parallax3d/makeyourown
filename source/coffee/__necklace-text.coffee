NecklaceText = (options) ->
	{font, str, radius, size, rotation} = options

	size = size or= 5.4
	rotation = rotation or=0
	height = 0.001

	geom = new THREE.Geometry

	textWidth = 0

	for lt, i in str.split ""
		options.shift = textWidth
		options.lt = lt
		options.twoWords = lt + str[ i+1 ]
		geometry = NeklaceLt options

		geom.merge geometry

		textWidth += geometry.width

#		obj.add2 textMesh

	obj = new THREE.Mesh geom, silverMaterial.clone()
#	obj.list = []
#	obj.add2 = (e) ->
#		# @list.push e
#		@add e
#	obj.add2To = (e, pos) ->
#		# @list.splice pos, 0, e
#		@add e
#	obj.remove2 = (index) ->
#		@remove @children[index]
	# @list.splice index, 1

	c = 0
	obj.textWidth = textWidth - c
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

NeklaceLt = (options) ->
	{font, lt, radius, size, index, twoWords, shift} = options
	size = size or= 5.4
	height = 0.001

	unless (/[a-zA-Zа-яА-Я]/g).test(lt)
		font = 'icomoon'
		size *= 2.0

	textGeom = new THREE.TextGeometry lt, { font: font, size: size, height: height, bevelEnabled: true, bevelThickness: 0.5, bevelSize: 0.2, curveSegments: 10 }

	c = 0.5
	if (/[А-Я]/g).test(lt)
		c = 0.8
	if (/[а-я]/g).test(lt)
		c = 0.5
	if (/[A-Z]/g).test(lt)
		c = 0.7
	console.log "________" + lt

	# For one word
	switch lt
		# eng
		when "f"
			c = 1.45
		when "t"
			c = 0.8
		when "l"
			c = 0.8
		when "M"
			c = 0.4
		when "S"
			c = 1.1
		when "p"
			c = 0.9
		when "j"
			c = 1.2
		when "d"
			c = 0.8
		when "g"
			c = 0.8
#		when "z"
#			c = 1.2
#		when "x"
#			c = 0.5
#		when "i"
#			c = 0.8
#		when "K"
#			c = 1.2
		# rus

		when "д"
			c = 0.9
		when "р"
			c = 0.9
#		when "у"
#			c = 1.4
#		when "з"
#			c = 1.2
#		when "б"
#			c = 2.9
#		when "я"
#			c = 0.6
		when "а"
			c = 0.6
#		when "е"
#			c = 0.4
#		when "и"
#			c = -1.2
#		when "Н"
#			c = 1
#		when "о"
#			c = -0.2
#		when "Б"
#			c = 0.9
#		when "м"
#			c = -1
#		when "ё"
#			c = 0.6
#		when "А"
#			c = 0.95
#		when "Е"
#				c = 0.2
#		when "Т"
#			c = 1.4
#		when "К"
#			c = 1.2
#		when "С"
#			c = 0.7
#		when "Г"
#			c = 3.3
#		when "М"
#			c = 0.8
#		when "П"
#			c = 1.4
#		when "И"
#			c = 0.3
#		when "В"
#			c = 0.8
#		when  "в"
#			c = 0.1
#		when  "н"
#			c = - 2.95
#		when  "с"
#			c = - 2.7
	# For tho twoWords
#	switch twoWords
#		when "оз"
#			c = 0.3
#		when "ут"
#			c = 1.2
#		when "Ст"
#			c = 1
#		when "д"
#			c = 1

	textGeom.computeBoundingBox()
	textGeom.applyMatrix new THREE.Matrix4().makeTranslation shift + c, 0, 0
	textGeom.width = textGeom.boundingBox.max.x - textGeom.boundingBox.min.x - c * 1.3
	textGeom.computeBoundingBox()

	return textGeom
