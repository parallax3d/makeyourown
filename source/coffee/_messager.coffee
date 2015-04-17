Messager = (callback) ->

	do addRotateModelHandlers

	[controls.minPolarAngle, controls.maxPolarAngle] = [0, Math.PI]		
	controls.maxDistance = 28
	camera.position.z = 100
	camera.position.y = 60
	

	if loadedModels.messager == null
		$("#ajax-loading").show()
		loader.load "obj/carve/ring.obj", (object) ->

			object.traverse (child) ->
				if child instanceof THREE.Mesh
					child.material = silverMaterial.clone()

			object.userData.ring = true
			object.scale.x = object.scale.y = object.scale.z = config.p3.size * 0.05
			combine = new THREE.Object3D
			combine.userData.model = true
			combine.add object

			text = RingText { str: "MYO", font: config.p3.defaultFont, radius: 8.9, size: 2.92 }, false, true
			text.userData.text = true
			text.scale.x = text.scale.y = text.scale.z = config.p3.size * 0.05
			text.position.z = text.radius*object.scale.x
			combine.add text
			combine.rotation.y = Math.PI/2
			combine.position.y = 5
			scene.add combine
			loadedModels.messager = combine.clone()

			$("#ajax-loading").hide()
			renderf()
	else
		combine = loadedModels.messager
		changeMaterialNew combine, modelParams.material
		scene.add combine
		

	modelParams.changeText = (str) ->

		for obj in scene.children when obj? and obj.userData.model == true
			r = null
			for ring in obj.children when ring.userData.ring == true
				r = ring
			for text in obj.children when text.userData.text == true
				obj.remove text

				newText = RingText { str: str, font: config.p3.defaultFont, radius: 8.9, size: 2.92 }, false, true
				newText.userData.text = true
				newText.scale.x = newText.scale.y = newText.scale.z = r.scale.x
				newText.position.z = newText.radius*r.scale.x
				obj.add newText
			changeMaterialNew obj, modelParams.material

	modelParams.changeFont = (currentStr, font) ->
		font or= config.p3.defaultFont
		config.p3.defaultFont = font

		modelParams.changeText(currentStr, font);

	modelParams.changeSize = (v) ->
		for obj in scene.children when obj? and obj.userData.model == true
			r = null
			for ring in obj.children when ring.userData.ring == true
				ring.scale.x = ring.scale.y = ring.scale.z = v*0.05
				r = ring
			for text in obj.children when text.userData.text == true
				text.scale.x = text.scale.y = text.scale.z = r.scale.x
				text.position.z = text.radius*r.scale.x
		modelParams.price()
		renderf()

	modelParams.functionsTable["p-selected-font"] = modelParams.changeFont
	modelParams.functionsTable["p-panel-text"] = modelParams.changeText
	modelParams.functionsTable["p-size"] = modelParams.changeSize