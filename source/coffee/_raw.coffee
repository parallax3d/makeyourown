Raw = (callback) ->

	do addRotateModelHandlers

	[controls.minPolarAngle, controls.maxPolarAngle] = [0, Math.PI]		
	controls.maxDistance = 38
	camera.position.z = 100
	camera.position.y = 80
	
	combine = new THREE.Object3D
	combine.userData.model = true

	if loadedModels.raw == null
		$("#ajax-loading").show()
		loader.load "obj/cross/left.obj", (object) ->

			object.traverse (child) ->
				if child instanceof THREE.Mesh
					child.material = silverMaterial.clone()

			object.children.last().userData.ring1 = true
			clone = object.children.last().clone() 
			clone.userData.ring2 = true

			
			combine.add object.children.last()
			combine.add clone
			
			text = RingText str: "MYO", font: config.p5.defaultFont, size: 3.585
			text.userData.text = true
			text.position.y = -0.03
			combine.add text

			clone.rotation.y = Math.PI + text.angleTotal

			combine.scale.x = combine.scale.y = combine.scale.z = config.p5.size*0.05
			combine.position.y = 10
			scene.add combine 

			loadedModels.raw = combine.clone()
			$("#ajax-loading").hide()
			renderf()
	else
		combine = loadedModels.raw
		scene.add combine
		changeMaterialNew combine, modelParams.material

	modelParams.changeText = (str) ->

		for obj in scene.children when obj? and obj.userData.model == true
			r = null
			for ring in obj.children when ring.userData.ring2 == true
				r = ring
			for text in obj.children when text.userData.text == true
				obj.remove text

				newText = RingText str: str, font: config.p5.defaultFont, size: 3.585
				newText.userData.text = true
				newText.position.y = -0.03
				r.rotation.y = Math.PI + newText.angleTotal
				obj.add newText

		changeMaterialNew combine, modelParams.material

	modelParams.changeFont = (currentStr, font) ->
		font or= config.p5.defaultFont
		config.p5.defaultFont = font

		modelParams.changeText(currentStr, font);

	modelParams.changeSize = (v) ->

		for obj in scene.children when obj? and obj.userData.model == true
			obj.scale.x = obj.scale.y = obj.scale.z = v*0.05

		modelParams.price()
		renderf()

	modelParams.functionsTable["p-selected-font"] = modelParams.changeFont
	modelParams.functionsTable["p-panel-text"] = modelParams.changeText
	modelParams.functionsTable["p-size"] = modelParams.changeSize
	modelParams.functionsTable["p-price"] = modelParams.price