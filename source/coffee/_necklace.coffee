Necklace = (callback) ->
	_global.rotate = false
	do removeRotateModelHandlers
	do addDriftModelHandlers

	controls.minPolarAngle = 1.25
	controls.maxPolarAngle = 1.4
	controls.maxDistance = 30
#	controls.center = new THREE.Vector3
#	controls.camera = new THREE.Vector3
	camera.position.x = 0
	camera.position.y = 0
	camera.position.z = 0

	combine = new THREE.Object3D
	combine.userData.combine = true

	model = new THREE.Object3D
	model.userData.model = true

	if loadedModels.necklace == null
		$("#ajax-loading").show()
		loader.load "obj/textnecklace/necklace.obj", (chainL) ->

			chainL.traverse (child) ->
				if child instanceof THREE.Mesh
					child.material = silverMaterial.clone()

			text = NecklaceText str: "myo", font: config.p4.defaultFont
			text.userData.text = true

			geom = new THREE.TorusGeometry 0.6, 0.2, 32, 32
			mesh = new THREE.Mesh geom, silverMaterial.clone()
			mesh.userData.torus1 = true

			mesh2 = new THREE.Mesh geom.clone(), silverMaterial.clone()
			mesh2.userData.torus2 = true

			chainR = chainL.clone()
			chainR.rotation.y = Math.PI
			chainL.userData.chainL = true
			chainR.userData.chainR = true

			modelParams.changeDraw(text, mesh, mesh2, chainL, chainR)

			model.add mesh
			model.add mesh2
			model.add text

			model.scale.x = model.scale.y = model.scale.z = 0.8

			combine.add model
			combine.add chainL
			combine.add chainR

			scene.add combine

			loadedModels.necklace = combine.clone()

			$("#ajax-loading").hide()
			renderf()
	else
		combine = loadedModels.necklace
		scene.add combine
		changeMaterialNew combine, modelParams.material

	modelParams.changeDraw = (text, torus1, torus2, chainL, chainR ) ->

		text.position.x = 0

		torus1.position.y = 1.0
		torus1.position.x = -text.textWidth/2 - 0.4

		chainL.position.y = 0.6
		chainL.position.x = -text.textWidth/2 + 0.8

		torus2.position.y = 1.0
		torus2.position.x = text.textWidth/2 + 0.4

		chainR.position.y = 0.6
		chainR.position.x =  text.textWidth/2 - 0.8

		text.position.x = -text.textWidth/2

#		for element in text.userData.symbols
#			object = new THREE.BoundingBoxHelper element.object, 0xff0000
#			object.update()
#			object.position.x = text.position.x + element.translateX + element.boxWidth/2
#			combine.add object

	modelParams.changeFont = (currentStr, font) ->
		font or= config.p4.defaultFont
		config.p4.defaultFont = font

		if font == "norican" and currentStr.match /[а-яА-ЯёЁ]/g
			return false
			 #$('#text-input').val(currentStr)

		modelParams.changeText ""

	modelParams.changeFont = (currentStr, font) ->
		font or= config.p4.defaultFont
		config.p4.defaultFont = font

		modelParams.changeText(currentStr);

	modelParams.changeText = (str) ->

		console.log 'xxx: ' + str

		if str.length > 11
			camera.position.z = 40
			controls.maxDistance = 40
		else
			controls.maxDistance = 30

		torus1Y = 0
		torus2Y = 0

		t1 = null
		t2 = null
		chainL = null
		chainR = null
		model = null

		for obj in combine.children when obj? and (obj.userData.model == true or obj.userData.chainL == true or obj.userData.chainR == true)

			if obj.userData.chainL == true
				chainL = obj
			else if obj.userData.chainR == true
				chainR = obj

			else
				model = obj
				for torus in obj.children when torus.userData.torus1 == true
					t1 = torus
				for torus in obj.children when torus.userData.torus2 == true
					t2 = torus
				for text in obj.children when text? and text.userData.text == true
					obj.remove text

		newText = NecklaceText str: str, font: config.p4.defaultFont
		newText.userData.text = true

		modelParams.changeDraw(newText, t1, t2, chainL, chainR)

		model.add newText

		changeMaterialNew model, modelParams.material

	modelParams.functionsTable["p-selected-font"] = modelParams.changeFont
	modelParams.functionsTable["p-panel-text"] = modelParams.changeText
