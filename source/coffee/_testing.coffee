Testing = (callback) ->
	_global.rotate = false
	do removeRotateModelHandlers
	do addDriftModelHandlers

	controls.minPolarAngle = 1.25
	controls.maxPolarAngle = 1.4
	controls.maxDistance = 50
	camera.position.x = 0
	camera.position.y = 0
	camera.position.z = 0

	combine = new THREE.Object3D
	combine.userData.model = true

	if loadedModels.testing == null
		$("#ajax-loading").show()

		text = NecklaceText str: "myo", font: config.p4.defaultFont
		text.userData.text = true
		text.position.x = -text.textWidth/2

		combine.add text

		scene.add combine

		loadedModels.testing = combine.clone()

		$("#ajax-loading").hide()
		renderf()
	else
		combine = loadedModels.testing
		scene.add combine
		changeMaterialNew combine, modelParams.material

	modelParams.changeFont = (currentStr, font) ->
		font or= config.p0.defaultFont
		config.p0.defaultFont = font

		modelParams.changeText currentStr

	modelParams.changeText = (str) ->

		console.log 'xxx: ' + str

		if str.length > 11
			camera.position.z = 40
			controls.maxDistance = 40
		else
			controls.maxDistance = 30

		for obj in scene.children when obj? and obj.userData.model == true
			for text in obj.children when text? and text.userData.text == true
				obj.remove text

			newText = NecklaceText str: str, font: config.p0.defaultFont
			newText.userData.text = true

			newText.position.x = -newText.textWidth/2

			obj.add newText

			changeMaterialNew obj, modelParams.material

	modelParams.functionsTable["p-selected-font"] = modelParams.changeFont
	modelParams.functionsTable["p-panel-text"] = modelParams.changeText
