Cufflink = (callback) ->
	do addRotateModelHandlers

	[controls.minPolarAngle, controls.maxPolarAngle] = [0, Math.PI]
	controls.maxDistance = 38
	camera.position.z = 200
	camera.position.y = 80

	combine = new THREE.Object3D
	combine.userData.model = true

	if loadedModels.cufflink == null
		loader.load "obj/ones.obj", (object) ->
			object.traverse (child) ->
				if child instanceof THREE.Mesh
					child.material = silverMaterial.clone()

			combine.add object

			text = NecklaceText str: "RR", font: config.p7.defaultFont, diagonal: true, leftBorder: 2.0, rightBorder: 1.5
			a = text.textWidth/(config.p7.size / 2)

			text.userData.text = true
			text.position.z = 1
			text.position.x = -text.textWidth/2
			text.position.y = -5
			text.scale.x = text.scale.y = text.scale.z = 2.5
			combine.add text

			combine.scale.x = combine.scale.y = combine.scale.z = config.p7.size * 0.05

			scene.add combine

			loadedModels.cufflink = combine.clone()
			$("#ajax-loading").hide()
			renderf()
	else
		combine = loadedModels.cufflink
		scene.add combine
		changeMaterialNew combine, modelParams.material

	modelParams.changeFont = (currentStr, font) ->
		font or= config.p7.defaultFont
		config.p7.defaultFont = font

		modelParams.changeText(currentStr);

	modelParams.changeText = (str) ->

		for obj in scene.children when obj? and obj.userData.model == true
			#r = null

			#for ring in obj.children when ring.userData.ring2 == true
			#	r = ring
			for text in obj.children when text? and text.userData.text == true

				obj.remove text

			newText = NecklaceText str: str, font: config.p7.defaultFont, diagonal: true
			newText.userData.text = true
			newText.position.z = 1
			newText.position.x = -newText.textWidth/2
			newText.position.y = -5
			newText.scale.x = newText.scale.y = newText.scale.z = 2.5
			a = newText.textWidth/(config.p7.size / 2)
#			r.rotation.z = -Math.PI/2 - a + (5 * Math.PI)/180

			obj.add newText

			changeMaterialNew obj, modelParams.material

	modelParams.changeSize = (v) ->

		for obj in scene.children when obj? and obj.userData.model == true
			obj.scale.x = obj.scale.y = obj.scale.z = v*0.05

			renderf()

	modelParams.functionsTable["p-selected-font"] = modelParams.changeFont
	modelParams.functionsTable["p-panel-text"] = modelParams.changeText
	modelParams.functionsTable["p-size"] = modelParams.changeSize