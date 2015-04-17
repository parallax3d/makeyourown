Necklace = (callback) ->
	_global.rotate = false
	do removeRotateModelHandlers
	do addDriftModelHandlers

	controls.minPolarAngle = 1.25
	controls.maxPolarAngle = 1.4
	controls.maxDistance = 30
	controls.center = new THREE.Vector3
	controls.camera = new THREE.Vector3
	camera.position.x = 0
	camera.position.y = 0
	camera.position.z = 25

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
# <<<<<<< HEAD
# 			object.position.y = -18.8
# 			object.position.x = -text.geometry.textWidth/2
# =======
			object.position.y = -19.0
			object.position.x = -text.textWidth/2
# >>>>>>> master
			object.userData.first = true

			clone = object.clone()
			clone.rotation.y = Math.PI
# <<<<<<< HEAD
# 			clone.position.x = text.geometry.textWidth/2
# =======
			clone.position.y = -19.0
			clone.position.x = text.textWidth/2
			clone.userData.first = undefined
# >>>>>>> master
			clone.userData.second = true

			# combine.add object
			# combine.add clone
			combine.position.y = 27

			text.position.y = -20
			text.position.x = -text.textWidth/2

			geom = new THREE.TorusGeometry 0.6,  0.2, 32, 32
			mesh = new THREE.Mesh geom, silverMaterial.clone()
			mesh.position.y = -18.7
			mesh.position.x = -text.textWidth/2
			mesh.userData.torus1 = true

			mesh2 = new THREE.Mesh geom.clone(), silverMaterial.clone()
			mesh2.userData.torus2 = true
			mesh2.position.y = -18.7
			mesh2.position.x = text.textWidth/2

			combine.add mesh
			combine.add mesh2
			combine.add text
# <<<<<<< HEAD

# =======
# >>>>>>> master
			scene.add combine

			loadedModels.necklace = combine.clone()

			$("#ajax-loading").hide()
			renderf()
# <<<<<<< HEAD

# 			modelParams.changeText "myo"
# =======
# >>>>>>> master
	else
		combine = loadedModels.necklace
		scene.add combine
		changeMaterialNew combine, modelParams.material

	modelParams.changeFont = (currentStr, font) ->
		font or= config.p4.defaultFont
		config.p4.defaultFont = font

# <<<<<<< HEAD
# 		# modelParams.changeText ""
# 		modelParams.changeText currentStr.toLowerCase()

# 	modelParams.changeText = (str) ->
# =======
		if font == "norican" and currentStr.match /[а-яА-ЯёЁ]/g
			return false
			# $('#text-input').val(currentStr)

		modelParams.changeText ""
		modelParams.changeText currentStr.toLowerCase()

	modelParams.changeText = (str, isEmpty) ->

		str = str.toLowerCase()
		console.log 'xxx: ' + str
# >>>>>>> master

		if str.length > 11
			camera.position.z = 40
			controls.maxDistance = 40
		else
			controls.maxDistance = 30

		torus1Y = 0
		torus2Y = 0

		for obj in scene.children when obj? and obj.userData.model == true

			for text in obj.children when text? and text.userData.text == true
# <<<<<<< HEAD
				obj.remove text

			newText = NecklaceText str: str, font: config.p4.defaultFont
			newText.userData.text = true
# # =======
# 				len = 0

# 				if str != text.nowText and str.length == 1 and text.nowText.length >= 1
# 					children = text.children.slice(0)
# 					textLen = children.length - 1
# 					for i in [0..textLen]
# 						text.textWidth -= children[i].width
# 						text.remove2 0
# 						text.nowText = ""

# 				JsDiff.diffChars(text.nowText, str).forEach (e) ->

# 					shiftLt = (lenn, r=false) ->
# 						if lenn < 1 then return
# 						if config.p4.defaultFont == 'calligraph'
# 							if text.list[0].lt == 'Q'
# 								torus1Y = -0.5
# 							if text.list[lenn - 1].lt == 't'
# 								text.list[lenn - 1].width += 0.2
# 								text.textWidth += 0.4

# 						if config.p4.defaultFont == 'norican'
# 							if text.list[lenn - 1].lt == 'x'
# 								text.list[lenn - 1].position.x -= 0.4
# 								text.textWidth -= 0.4
# 							if text.list[lenn - 1].lt == 'd' or text.list[lenn - 1].lt == 't' or text.list[lenn - 1].lt == 'g'
# 								text.list[lenn - 1].width += 0.8
# 								text.textWidth += 0.8
# 							if text.list[lenn - 1].lt == 'f'
# 								text.list[lenn - 1].width += 1.2
# 								text.textWidth += 1.2
# 							if text.list[lenn - 1].lt == 'j'
# 								text.list[lenn - 1].width += 1.0
# 								text.textWidth += 1.0


# 					if e.added
# 						e.value.split("").forEach (x, i) ->
# 							textMesh = NeklaceLt lt: x, font: config.p4.defaultFont, shift: text.textWidth
# 							text.add2To textMesh

# 							text.textWidth += textMesh.width
# 							len += 1

# 					if e.removed
# 						e.value.split("").forEach (e, i) ->

# 							ilen = len + i

# 							text.textWidth -= text.children[text.children.length - 1].width
# 							text.remove2 text.children.length - 1
# 							len -= 1


# # >>>>>>> master

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
			for torus in obj.children.slice(0) when torus? and (torus.userData.torus2 == true)
				torus.position.x = newText.textWidth/2 - c2

# <<<<<<< HEAD
			for first in obj.children when first.userData.first == true
				first.position.x = -newText.geometry.textWidth/2 - c1
			for second in obj.children when second.userData.second == true
				second.position.x = newText.geometry.textWidth/2 - c2
# =======
				# for first in obj.children when first.userData.first == true
				# 	first.position.x = -text.textWidth/2 - c1
				# 	first.position.y = -19.0 + torus1Y
				# for second in obj.children when second.userData.second == true
				# 	second.position.x = text.textWidth/2 - c2
				# 	second.position.y = -19.0 + torus2Y
# >>>>>>> master

			changeMaterialNew obj, modelParams.material

	modelParams.functionsTable["p-selected-font"] = modelParams.changeFont
	modelParams.functionsTable["p-panel-text"] = modelParams.changeText
