NecklaceText = (options) ->
	{font, str, radius, size} = options

	size = size or= 5.4
	height = 0.001


	obj = new THREE.Object3D
	obj.list = []
	obj.add2 = (e) ->
		# @list.push e
		@add e
	obj.add2To = (e, pos) ->
		# @list.splice pos, 0, e
		@add e
	obj.remove2 = (index) ->
		@remove @children[index]
		# @list.splice index, 1

	textWidth = 0

	for lt, i in str.split ""
		options.shift = textWidth
		options.lt = lt
		textMesh = NeklaceLt options

		textWidth += textMesh.width

		obj.add2 textMesh

	c = 0
	# if str[0] == "j"
	# 	c += 2
	# if str.slice -1 == "в"
	# 	c += 0.0
	# if str[0] == "р"
	# 	c += 0.6
	# if str[0] == "p"
	# 	c += 0.6
	# if str[0] == "f"
	# 	c += 1.3
	# if str.slice -1 == "ь" || str.slice -1 == "ъ"
	# 	c -= 0.8
	# if str.slice -1 == "з"
	# 	c += 0.8
	# if str.slice -1 == "у"
	# 	c += 0.5
	# if str.slice -1 == "ю"
	# 	c -= 0.8
	# if str.slice -1 == "d"
	# 	c += 0.4
	# if str[str.length - 1] == "б"
	# 	c += 2.0
	# if str[str.length - 1] == "t"
	# 	c += 0.5
	# if str[str.length - 1] == "d"
	# 	c += 0.5
	# if str[str.length - 1] == "f"
	# 	c += 0.5
	# if str[str.length - 1] == "l"
	# 	c += 0.5
	# if font == 'norican'
	# 	if str.slice -1 == "x"
	# 		c -= 0.4

	obj.textWidth = textWidth - c
	obj.nowText = str

	return obj

NeklaceLt = (options) ->
	{font, lt, radius, size, index} = options
	size = size or= 5.4
	height = 0.001
	textGeom = new THREE.TextGeometry lt, { font: font, size: size, height: height, bevelEnabled: true, bevelThickness: 0.5, bevelSize: 0.2, curveSegments: 10 }

	textGeom.computeBoundingBox()

	textMesh = new THREE.Mesh textGeom, silverMaterial.clone()
	textMesh.position.x = options.shift
	textMesh.lt = lt
	c = 0.7
	switch lt
		# eng
		when "t"
			c = 1.6
		when "l"
			c = 1.6
		when "p"
			c = 1.7
		when "f"
			c = 2.8
		when "g"
			c = 1.4
		when "j"
			c = 2.6
		when "d"
			c = 1.6
		when "y"
			c = 1.2
		when "z"
			c = 1.2
		when "x"
			c = 0.8
		# rus
		when "д"
			c = 1.4
		when "р"
			c = 1.4
		when "у"
			c = 1.4
		when "з"
			c = 1.2
		when "б"
			c = 2.9


	textMesh.width = textGeom.boundingBox.max.x - textGeom.boundingBox.min.x - c*1.2


	return textMesh