Cufflink = (callback) ->
	do addRotateModelHandlers

	[controls.minPolarAngle, controls.maxPolarAngle] = [0, Math.PI]
	controls.maxDistance = 38
	camera.position.z = 100
	camera.position.y = 80

	combine = new THREE.Object3D
	combine.userData.model = true

	if loadedModels.cufflink == null
		text = NecklaceText str: "myo", font: config.p7.defaultFont
		a = text.textWidth/(config.p7.size / 2)

		text.userData.text = true
		text.position.z = 3
		text.position.x = -text.textWidth/2
		text.position.y = -1
		combine.add text

		geom = new THREE.CylinderGeometry 0.4,0.4, 6, 50
		mesh = new THREE.Mesh geom, silverMaterial.clone()
		mesh.rotation.z = Math.PI/2
		mesh.rotation.y = -Math.PI/2
		#mesh.position.y = 1.0
#		mesh.userData.ring1 = true
		combine.add mesh

		geom2 = new THREE.CylinderGeometry 2.5,2.5,0.8 , 50
		mesh2 = new THREE.Mesh geom2, silverMaterial.clone()
		mesh2.rotation.z = Math.PI/2
		mesh2.rotation.y = -Math.PI/2
		mesh2.position.z = -3
		combine.add mesh2
#
		combine.scale.x = combine.scale.y = combine.scale.z = config.p7.size * 0.05
#		combine.position.y = 9


		scene.add combine


		loadedModels.cufflink = combine.clone()
		$("#ajax-loading").hide()
		renderf()
	else
		combine = loadedModels.cufflink
		scene.add combine
		changeMaterialNew combine, modelParams.material

	modelParams.changeFont = (currentStr, font) ->
		font or= config.p6.defaultFont
		config.p6.defaultFont = font

		modelParams.changeText(currentStr);

	modelParams.changeText = (str) ->

		for obj in scene.children when obj? and obj.userData.model == true
			#r = null

			#for ring in obj.children when ring.userData.ring2 == true
			#	r = ring
			for text in obj.children when text? and text.userData.text == true

				obj.remove text

			newText = NecklaceText str: str, font: config.p7.defaultFont
			newText.userData.text = true
			newText.position.z = 3
			newText.position.x = -newText.textWidth/2
			newText.position.y = -1

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