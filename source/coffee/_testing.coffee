Testing = (callback) ->
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
		mesh.rotation.z = Math.PI/2 - (2 * Math.PI)/180
		mesh.rotation.x = Math.PI/2
		mesh.position.y = 1.0
		mesh.userData.ring1 = true
		combine.add mesh

		clone = mesh.clone()
		clone.userData.ring2 = true
		clone.rotation.x = Math.PI/2
		clone.rotation.z = -Math.PI/2 - a + (5 * Math.PI)/180
		clone.position.y = 1.0
		combine.add clone

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
		font or= config.p6.defaultFont
		config.p6.defaultFont = font

		modelParams.changeText(currentStr);

	modelParams.changeText = (str) ->

		for obj in scene.children when obj? and obj.userData.model == true
			r = null

			for ring in obj.children when ring.userData.ring2 == true
				r = ring
			for text in obj.children when text? and text.userData.text == true

				obj.remove text

			newText = NecklaceText str: str, font: config.p4.defaultFont, rotation: (config.p6.size / 2)
			newText.userData.text = true
			newText.position.z = config.p6.size / 2

			a = newText.textWidth/(config.p6.size / 2)
			r.rotation.z = -Math.PI/2 - a + (5 * Math.PI)/180

			obj.add newText

			changeMaterialNew obj, modelParams.material

	modelParams.changeSize = (v) ->

		for obj in scene.children when obj? and obj.userData.model == true
			obj.scale.x = obj.scale.y = obj.scale.z = v*0.05

		renderf()

	modelParams.functionsTable["p-selected-font"] = modelParams.changeFont
	modelParams.functionsTable["p-panel-text"] = modelParams.changeText
	modelParams.functionsTable["p-size"] = modelParams.changeSize