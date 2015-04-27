RawRound = (callback) ->
	do addRotateModelHandlers

	[controls.minPolarAngle, controls.maxPolarAngle] = [0, Math.PI]
	controls.maxDistance = 38
	camera.position.z = 100
	camera.position.y = 80

	combine = new THREE.Object3D
	combine.userData.model = true

	if loadedModels.rawround == null
		text = NecklaceText str: "myo", font: config.p6.defaultFont, rotation: ( config.p6.size / 2 )
		a = text.textWidth/(config.p6.size / 2)

		text.userData.text = true
		text.position.z = config.p6.size / 2
#		text.position.x = 0.6
		combine.add text

		ring = new THREE.Object3D
		geom = new THREE.TorusGeometry config.p6.size/2, 0.5, 20, 50, Math.PI
		mesh = new THREE.Mesh geom, silverMaterial.clone()
		mesh.userData.ring1 = true
		ring.add mesh

		clone = mesh.clone()
		clone.userData.ring2 = true
		clone.rotation.z = Math.PI - a + (5* Math.PI)/180
		ring.add clone

		ring.userData.ring = true
		ring.rotation.z = Math.PI/2 - (2* Math.PI)/180
		ring.rotation.x = Math.PI/2
		ring.position.y = 1.0
		combine.add ring

		combine.scale.x = combine.scale.y = combine.scale.z = config.p6.size * 0.05
		combine.position.y = 9

		scene.add combine

		loadedModels.rawround = combine.clone()
		$("#ajax-loading").hide()
		renderf()
	else
		combine = loadedModels.rawround
		scene.add combine
		changeMaterialNew combine, modelParams.material

	modelParams.changeFont = (currentStr, font) ->
		font or= config.p4.defaultFont
		config.p4.defaultFont = font

		if font == "norican" and currentStr.match /[а-яА-ЯёЁ]/g
			return false

		modelParams.changeText ""

	modelParams.changeText = (str, isEmpty) ->

		for obj in scene.children when obj? and obj.userData.model == true
			r = null

			for ring in obj.children when ring.userData.ring == true
				r = ring
			for text in obj.children when text? and text.userData.text == true

				obj.remove text

			newText = NecklaceText str: str, font: config.p4.defaultFont, rotation: (config.p6.size / 2)
			newText.userData.text = true
			newText.position.z = config.p6.size / 2

			a = newText.textWidth/(config.p6.size / 2)
			for ring2 in r.children when ring2.userData.ring2 == true
				ring2.rotation.z =  Math.PI - a + (5* Math.PI)/180

			obj.add newText

			changeMaterialNew obj, modelParams.material

	modelParams.functionsTable["p-selected-font"] = modelParams.changeFont
	modelParams.functionsTable["p-panel-text"] = modelParams.changeText
