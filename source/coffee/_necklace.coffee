Necklace = (callback) ->
	_global.rotate = false
	do removeRotateModelHandlers
	do addDriftModelHandlers

	controls.minPolarAngle = 1.25
	controls.maxPolarAngle = 1.4
	controls.maxDistance = 50
#	controls.center = new THREE.Vector3
#	controls.camera = new THREE.Vector3
	camera.position.x = 0
	camera.position.y = 0
	camera.position.z = 40

	combine = new THREE.Object3D
	combine.userData.model = true

	if loadedModels.necklace == null
		$("#ajax-loading").show()
		loader.load "obj/textnecklace/necklace.obj", (object) ->

			object.traverse (child) ->
				if child instanceof THREE.Mesh
					child.material = silverMaterial.clone()

			text = NecklaceText str: "myo", font: config.p4.defaultFont
			text.userData.text = true

			geom = new THREE.TorusGeometry 0.6, 0.2, 32, 32
			mesh = new THREE.Mesh geom, silverMaterial.clone()
			mesh.userData.torus1 = true

			mesh2 = new THREE.Mesh geom.clone(), silverMaterial.clone()
			mesh2.userData.torus2 = true

			modelParams.changeDraw(text, mesh, mesh2)

			combine.add mesh
			combine.add mesh2
			combine.add text

			scene.add combine

			loadedModels.necklace = combine.clone()

			$("#ajax-loading").hide()
			renderf()
	else
		combine = loadedModels.necklace
		scene.add combine
		changeMaterialNew combine, modelParams.material

	modelParams.changeDraw = (text, torus1, torus2) ->
		raycaster = new THREE.Raycaster()

		text.position.x = 0

		#  left to right
		origin1 = new THREE.Vector3( 0, 0, 0)
		direction1=  new THREE.Vector3(1,0,0)
		raycaster.set( origin1, direction1 )
		intersects1 = raycaster.intersectObject( text )

		#  right to left
		origin1 = new THREE.Vector3( text.textWidth, 0, 0)
		direction1=  new THREE.Vector3(-1,0,0)
		raycaster.set( origin1, direction1 )
		intersects2 = raycaster.intersectObject( text )

		torus1.position.y = 1.3
		torus1.position.x = -text.textWidth/2 - intersects1[0].distance + 0.6

		torus2.position.y = 1.3
		torus2.position.x = text.textWidth/2 + intersects2[0].distance - 0.6

		text.position.x = -text.textWidth/2

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

			t1 = null
			t2 = null

			for torus in obj.children when torus.userData.torus1 == true
				t1 = torus
			for torus in obj.children when torus.userData.torus2 == true
				t2 = torus
			for text in obj.children when text? and text.userData.text == true
				obj.remove text

			newText = NecklaceText str: str, font: config.p4.defaultFont
			newText.userData.text = true

			modelParams.changeDraw(newText, t1, t2)

			obj.add newText

#			c1 = 0
#			c2 = 0
#			if str[0] == "л" or str[0] == "м"
#				c1 -= 1.0
#			if str.slice -1 == "л" or str.slice -1 == "м"
#				c2 -= 0.5
#
#			for torus in obj.children.slice(0) when torus? and (torus.userData.torus1 == true)
#				torus.position.x = -newText.textWidth/2 - c1
#			for torus in obj.children.slice(0) when torus? and (torus.userData.torus2 == true)
#				torus.position.x = newText.textWidth/2 - c2
#
#			for first in obj.children when first.userData.first == true
#				first.position.x = -newText.geometry.textWidth/2 - c1
#			for second in obj.children when second.userData.second == true
#				second.position.x = newText.geometry.textWidth/2 - c2

			changeMaterialNew obj, modelParams.material

	modelParams.functionsTable["p-selected-font"] = modelParams.changeFont
	modelParams.functionsTable["p-panel-text"] = modelParams.changeText
