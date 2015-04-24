RawRound = (callback) ->
	_global.rotate = false
	do removeRotateModelHandlers
	do addDriftModelHandlers

	[controls.minPolarAngle, controls.maxPolarAngle] = [0, Math.PI]
	controls.maxDistance = 38
	camera.position.z = 100
	camera.position.y = 80

	combine = new THREE.Object3D
	combine.userData.model = true

	if loadedModels.rawround == null
		$("#ajax-loading").show()
		loader.load "obj/textnecklace/necklace.obj", (object) ->

			object.traverse (child) ->
				if child instanceof THREE.Mesh
					child.material = silverMaterial.clone()

			text = NecklaceText str: "myo", font: config.p6.defaultFont, rotation: 9.55
			text.userData.text = true
			object.position.y = -10.0
			object.position.x = -text.textWidth/2
			object.userData.first = true

			clone = object.clone()
			clone.rotation.y = Math.PI
			clone.position.y = -19.0
			clone.position.x = text.textWidth/2
			clone.userData.first = undefined
			clone.userData.second = true

			# combine.add object
			# combine.add clone
			combine.position.y = 27

			text.position.y = -20
			text.position.x = -text.textWidth/2

			a = text.textWidth/9.55
			geom = new THREE.TorusGeometry 9.55, 0.5, 50, 50, Math.PI*2 - a
			mesh = new THREE.Mesh geom, silverMaterial.clone()
			mesh.rotation.x = Math.PI/2
			mesh.rotation.z = Math.PI
			mesh.position.y = -20
			mesh.position.z = -10
			#mesh.rotation.y = a
			mesh.userData.torus1 = true

			combine.add mesh
			combine.add text

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
			 #$('#text-input').val(currentStr)

		modelParams.changeText ""

	modelParams.changeText = (str, isEmpty) ->

		console.log 'xxx: ' + str

		if str.length > 11
			camera.position.z = 40
			controls.maxDistance = 40
		else
			controls.maxDistance = 30

		torus1Y = 0
		torus2Y = 0

		for obj in scene.children when obj? and obj.userData.model == true

			for text in obj.children when text? and text.userData.text == true

				obj.remove text

			newText = NecklaceText str: str, font: config.p4.defaultFont, rotation: 9.55
			newText.userData.text = true
			newText.position.y = -20
			newText.position.x = -newText.textWidth/2

			obj.add newText

			c1 = 0
			c2 = 0
			if str[0] == "л" or str[0] == "м"
				c1 -= 1.0
			if str.slice -1 == "л" or str.slice -1 == "м"
				c2 -= 0.5

			for torus in obj.children.slice(0) when torus? and (torus.userData.torus1 == true)
				torus.position.x = -newText.textWidth/2 - c1
			#for torus in obj.children.slice(0) when torus? and (torus.userData.torus2 == true)
				#torus.position.x = newText.textWidth/2 - c2

			for first in obj.children when first.userData.first == true
				first.position.x = -newText.geometry.textWidth/2 - c1
			#for second in obj.children when second.userData.second == true
				#second.position.x = newText.geometry.textWidth/2 - c2

			changeMaterialNew obj, modelParams.material

	modelParams.functionsTable["p-selected-font"] = modelParams.changeFont
	modelParams.functionsTable["p-panel-text"] = modelParams.changeText
