RingText = (options, offsetsDisabled=false, messager=false) ->
	{font, str, radius, size, height} = options
	radius = radius or= 9.57
	angleTotal = 0
	aT = 0
	shiftRotation = 0.01
	shiftStep = 0.4

	size = size or= 3.5
	height = height or= 1.22

	geom = new THREE.Geometry

	c = 0
	for f in [0...str.length]
		textGeom = new THREE.TextGeometry str[f], { font: font, size: size, height: height}

		qos = (b) ->
			b.computeBoundingBox()
			d = b.boundingBox
			a = new THREE.Vector3()
			a.addVectors(d.min, d.max)
			a.multiplyScalar(-0.5)
			b.applyMatrix new THREE.Matrix4().makeTranslation(a.x, a.y, a.z)
			b.computeBoundingBox()
			return a
		qos textGeom
		textGeom.textWidth = textGeom.boundingBox.max.x - textGeom.boundingBox.min.x

		c += textGeom.textWidth / 2

		chD = (tArr, c, x) =>
			res = c
			for i in [0...tArr.length]
				t = tArr[i]
				t1 = t[0]
				t2 = t[1]

				if t2 == str[f] && t1 == str[f - 1]
					res -= x
				else if t1 == str[f - 1] && t2 == "*"
					res -= x
				else if t2 == str[f] && t1 == "*"
					res -= x

			return res

		if ("W" == str[f])
			if ("A" == str[parseInt(f) - 1])
				c -= 1.35

			if ("L" == str[parseInt(f) - 1])
				c -= 1


		if ("T" == str[f])
			if ("A" == str[parseInt(f) - 1])
				c -= 0.3

			if ("L" == str[parseInt(f) - 1])
				c -= 1.1


		if ("V" == str[f])
			if ("A" == str[parseInt(f) - 1])
				c -= 1.45

			if ("L" == str[parseInt(f) - 1])
				c -= 1.35

			if ("P" == str[parseInt(f) - 1])
				c -= 0.6

			if ("F" == str[parseInt(f) - 1])
				c -= 0.6

			if ("D" == str[parseInt(f) - 1])
				c -= 0.4

			if ("B" == str[parseInt(f) - 1])
				c -= 0.5

			if ("R" == str[parseInt(f) - 1])
				c -= 0.3


		if ("Y" == str[f])
			if ("A" == str[parseInt(f) - 1])
				c -= 1.45

			if ("L" == str[parseInt(f) - 1])
				c -= 1.35

			if ("P" == str[parseInt(f) - 1])
				c -= 0.5

			if ("F" == str[parseInt(f) - 1])
				c -= 0.5

			if ("D" == str[parseInt(f) - 1])
				c -= 0.5

			if ("B" == str[parseInt(f) - 1])
				c -= 0.5

			if ("R" == str[parseInt(f) - 1])
				c -= 0.5

			if ("O" == str[parseInt(f) - 1])
				c -= 0.5


		if ("A" == str[f])
			if ("W" == str[parseInt(f) - 1])
				c -= 1.35

			if ("T" == str[parseInt(f) - 1])
				c -= 1.35

			if ("Y" == str[parseInt(f) - 1])
				c -= 1.45

			if ("V" == str[parseInt(f) - 1])
				c -= 1.45

			if ("P" == str[parseInt(f) - 1])
				c -= 1

			if ("F" == str[parseInt(f) - 1])
				c -= 0.55

			if ("D" == str[parseInt(f) - 1])
				c -= 0.4


		if ("J" == str[f])
			if ("W" == str[parseInt(f) - 1])
				c -= 1

			if ("T" == str[parseInt(f) - 1])
				c -= 1.1

			if ("Y" == str[parseInt(f) - 1])
				c -= 1.4

			if ("V" == str[parseInt(f) - 1])
				c -= 1.35

			if ("P" == str[parseInt(f) - 1])
				c -= 0.3

			if ("F" == str[parseInt(f) - 1])
				c -= 0.5


		if ("O" == str[f])
			if ("Y" == str[parseInt(f) - 1])
				c -= 0.2


		if ((/[а-яА-Я]/g).test(str[f]))
			if ("Г" == str[parseInt(f) - 1])
				c += 0.3



		if ("З" == str[f] || "Х" == str[f] || "Ф" == str[f] || "О" == str[f] || "Л" == str[f] || "Э" == str[f] || "Я" == str[f] || "С" == str[f])
			if ("Г" == str[parseInt(f) - 1])
				c -= 0.5



		if ("У" == str[f] || "З" == str[f] || "Х" == str[f] || "Ъ" == str[f] || "Л" == str[f] || "Д" == str[f] || "Ж" == str[f] || "Э" == str[f] || "Т" == str[f])
			if ("О" == str[parseInt(f) - 1])
				c -= 0.15


		# А Д
		if ("А" == str[f])
			if ("Г" == str[parseInt(f) - 1])
				c -= 0.9


		if ("Д" == str[f])
			if ("Г" == str[parseInt(f) - 1])
				c -= 0.6



		if ("О" == str[f])
			if ("М" == str[parseInt(f) - 1])
				c += 0.3

		if ("О" == str[f])
			if ("К" == str[parseInt(f) - 1])
				c -= 0.0

		if ("Т" == str[f])
			if ("А" == str[parseInt(f) - 1])
				c -= 0.6


		if ("Р" == str[f] || "В" == str[f] || "Ш" == str[f] || "И" == str[f] || "М" == str[f] || "Й" == str[f] || "Г" == str[f] || "Щ" == str[f] || "Е" == str[f] || "Ц" == str[f] || "Ь" == str[f] || "Ё" == str[f] || "К" == str[f] || "Б" == str[f] || "Ю" == str[f])
			if ("П" == str[parseInt(f) - 1])
				c += 0.4



		if ("Ч" == str[f] || "Ъ" == str[f])
			if ("П" == str[parseInt(f) - 1])
				c -= 0.2


		if ("Ъ" == str[f])
			if ("Ь" == str[parseInt(f) - 1])
				c -= 0.4


		if ("Ь" == str[f])
			if ("Ъ" == str[parseInt(f) - 1])
				c += 0.3



		c = chD(["КС", "КФ", "КО", "СО", "ХО", "ТО", "ТЛ", "ТД", "ТС", "ТЯ", "ТО", "АЬ", "АЧ", "АФ", "ЮЛ", "ЮЪ", "ЮД", "ЮУ", "ЮЖ", "ЮЗ", "ЮТ", "ФЗ", "ФЖ", "ФУ", "ЖС", "ЖФ", "ЖО", "РА", "ХФ"], c, 0.25)

		c = chD(["АЪ", "ЦЪ", "ЦЧ", "ЦТ", "ЩЪ", "ЩЧ", "ЩТ", "ЪУ", "ЪЪ", "ФЪ"], c, 0.4)

		c = chD(["ФТ", "ЪТ", "ТА"],	c, 0.6)

		c = chD(["*Ы"],	c, 0.0)

		c = chD(["УА"],	c, 0.69)

		if messager
			c = chD(["Ф*"],	c, -0.99)
		else
			c = chD(["Ф*"],	c, 0.39)
		c = chD(["ФЫ"],	c, -0.49)

		if ("X" == str[f])
			if ("D" == str[parseInt(f) - 1])
				c -= 0.7

			if ("B" == str[parseInt(f) - 1])
				c -= 0.35

			if ("R" == str[parseInt(f) - 1])
				c -= 0.3


		if ("У" == str[f])
			textGeom.applyMatrix new THREE.Matrix4().makeTranslation 0, -0.05, 0


		if ("1" != str[f])
			if ("1" == str[f - 1])
		 		c += 1.5

		if "I" == str[f] and f < str.length - 1
			if ("I" != str[f - 1])
				c += 0.405

		if "I" != str[f] and f < str.length - 1
			if ("I" == str[f - 1])
				c += 0.405

		if messager
			c += 0.8


		y = if str[f] == "Ц" or str[f] == "Щ"
				-0.0
			else if str[f] == "Д"
				-0.0
			else if str[f] == "Й"
				-0.0
			else if str[f] == "Ё"
				0.0
			else
				0

		textGeom.applyMatrix new THREE.Matrix4().makeTranslation c, y, 0

		y = if str[f] == "Й" then 1.00 else 1
		y = if str[f] == "Д" then 1.01 else 1

		textGeom.applyMatrix new THREE.Matrix4().makeScale 1, y, 1


		if ("S" == str[f] or "Z" == str[f] or "X" == str[f] or "Я" == str[f] or "З" == str[f] or "У" == str[f] or "Э" == str[f]) and f == 0
			textGeom.applyMatrix new THREE.Matrix4().makeTranslation -0.2, 0, 0

		if ("Ы" == str[f]) and f == 0
			textGeom.applyMatrix new THREE.Matrix4().makeTranslation -0.6, 0, 0

		if ("Ф" == str[f]) and not messager
			textGeom.applyMatrix new THREE.Matrix4().makeTranslation -3.2, -0.95, 0


		unless ("Ф" == str[f])
			c += textGeom.textWidth/2 - 0.4


		if ("Ы" == str[f]) and !offsetsDisabled and f < str.length - 1
		 	c -= 0.3


		if offsetsDisabled
			c += textGeom.textWidth - 0.8

		aT = c+0.1


		geom.merge textGeom


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

	textMesh = new THREE.Mesh geom, silverMaterial.clone()
	if messager
		textRotation geom, new THREE.Vector3(0, 0, -8.9) #-9.55)
	else
		textRotation geom, new THREE.Vector3(0, 0, -9.55)

	if ("Ф" == str)
		aT -= 0.15
	if str.length >= 7
		aT -= 0.19
	if str.length >= 3
		aT -= 0.1

	textMesh.angleTotal = aT*0.107

	textMesh.position.z = radius/textMesh.scale.x
	textMesh.radius = radius

	return textMesh
