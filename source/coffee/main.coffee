Array::last = -> @[@length - 1]

# String::last = -> @[@length - 1]

size =
	width: $("#cont").width()
	height: $("#cont").height()

modelParams =
	material: "silver"
	functionsTable:
		"p-model-id": (v) -> console.log v
		"p-material": (v) -> modelParams.material = v

	changeSize: (v) ->
		modelParams.size = v
		for obj in scene.children when obj? and obj.userData.model == true
			for ring in obj.children when ring.userData.ring == true
				ring.scale.x = ring.scale.y = ring.scale.z = v*0.05
		modelParams.price()
		renderf()

loadedModels =
	testing: null
	diamondRing: null
	mring: null
	messager: null
	necklace: null
	raw: null
	rawround: null
	cufflink: null

$(document).ready ->

	$(window).bind "beforeunload", (e) ->
		$("canvas").hide()
		return e.preventDefault()

	$(window).on 'hashchange', ->
		# only four model
		n = parseInt location.hash[1]
		# n = 1 if n != 4 or n != 1
		loadModel n

	unless Detector.webgl
		$("#no-webgl").show()
	else
		n = parseInt location.hash[1]
		# n = 1 if n != 4 or n != 1
		initGraphics()

		n = if isNaN n then 1 else n
		loadModel n

loadModel = (n) ->
	$("canvas").hide()

	cfg = config["p#{n}"]

	$("#panel").html ""
	$("#panel").css "height", cfg.height

	$("#menu a[pid]")
		.parent()
		.removeClass "active-menu"

	$("#menu a[pid='p#{n}']").parent().addClass "active-menu"

	for obj in scene.children when obj? and ( obj.userData.model == true or obj.userData.combine == true ) then scene.remove obj if scene?

	$("#panel").load "panels/p#{n}.html", ->
		$("form").attr "action", formPost
		$("#submit").click -> $("form").submit()

		$('.gold').click ->
			changeMaterialNew scene, "gold"
			modelParams.material = "gold"
			$("input[name=p-material]").val modelParams.material

		$('.whiteGold').click ->
			changeMaterialNew scene, "whiteGold"
			modelParams.material = "whiteGold"
			$("input[name=p-material]").val modelParams.material

		$('.silver').click ->
			changeMaterialNew scene, "silver"
			modelParams.material = "silver"
			$("input[name=p-material]").val modelParams.material

		$('.silver, .gold, .whiteGold').tooltip
			position:
				my: "center top"
				at: "center bottom"

		initPanel()

		$("canvas").show()

	cfg.model() if cfg?
	model = null

	modelParams.price = =>
		$("#price").html (cfg.price model).toFixed 2
		$("input[name=p-price]").val parseInt $("#price").html()

	modelParams.functionsTable["p-price"] = modelParams.price

fromJSON = (json) ->
	obj = JSON.parse(json)

	$("input[name=p-material]").val obj["p-material"]
	modelParams.functionsTable["p-material"](obj["p-material"])

	for key, value of obj when key isnt "p-model-id" and key isnt "p-material" and key isnt "p-price"
		$("input[name=#{key}]").val(value)
		console.log "#{key} -> #{value}"
		if key == "p-selected-font"
			modelParams.functionsTable["#{key}"](obj["p-panel-text"], value)

		else if key == "p-ring-diamond"
			modelParams.functionsTable["#{key}"](value, obj["p-size-diamond"])
		else if key isnt "p-size-diamond"
			modelParams.functionsTable["#{key}"](value)

	modelParams.price()

	return

exportFaces = (mesh, matrix) ->
	exportFacesMesh = (obj, geometry) ->
		lines = []
		geometry.computeFaceNormals()
		faces = geometry.faces
		vertices = geometry.vertices

		for v in [0..faces.length]
			face = faces[v]
			if face?
				a = vertices[face.a]
				a = new THREE.Vector3(a.x, a.y, a.z)
				a.applyMatrix4 obj.matrix

				b = vertices[face.b]
				b = new THREE.Vector3(b.x, b.y, b.z)
				b.applyMatrix4 obj.matrix

				c = vertices[face.c]
				c = new THREE.Vector3(c.x, c.y, c.z)
				c.applyMatrix4 obj.matrix

				lines.push "facet normal " + face.normal.x.toExponential() + " " + face.normal.y.toExponential() + " " + face.normal.z.toExponential() + ""
				lines.push "    outer loop"
				lines.push "        vertex  " + a.x.toExponential() + " " + a.y.toExponential() + " " + a.z.toExponential() + ""
				lines.push "        vertex  " + b.x.toExponential() + " " + b.y.toExponential() + " " + b.z.toExponential() + ""
				lines.push "        vertex  " + c.x.toExponential() + " " + c.y.toExponential() + " " + c.z.toExponential() + ""
				lines.push "    endloop"
				lines.push "endfacet"

		return lines

	lines = []
	for obj3d in mesh.children
		lines = lines.concat(exportFacesMesh(obj3d, obj3d.geometry)) if obj3d? and obj3d.geometry?

	if mesh.children.length == 0
		lines = lines.concat(exportFacesMesh(mesh, mesh.geometry)) if mesh? and mesh.geometry?

	return lines

exportSTL = ->
	stllines = []
	stllines.push "solid name"

	func = (objmodel) =>

		for x in objmodel.children when not x.userData.second? and not x.userData.first?
			stllines = stllines.concat exportFaces x, objmodel.matrix
			func x

	extruct = (obj) =>

		for obj in obj.children
			if obj.userData.model == true
				func obj
			else if obj.userData.combine == true
				extruct obj

	extruct(scene)

	stllines.push "endsolid name"

	result = stllines.join "\n"
	console.log result
	blob = new Blob [result], {
		type: "text/plaincharset=utf-8"
	}

	saveAs blob, "model.stl"

(($) ->
  $.fn.extend donetyping: (callback, timeout) ->
    timeout = timeout or 1e3 # 1 second default timeout
    timeoutReference = undefined
    doneTyping = (el) ->
      return  unless timeoutReference
      timeoutReference = null
      callback.call el
      return

    @each (i, el) ->
      $el = $(el)
      $el.is(":input") and $el.on("input", ->
        clearTimeout timeoutReference  if timeoutReference
        timeoutReference = setTimeout(->
          doneTyping el
          return
        , timeout)
        return
      ).blur(->
        doneTyping el
        return
      )
      return


  return
) jQuery

initPanel = ->

	$("#size a.plus").click ->
		v = parseFloat $("#p-size-display").val()
		if v < 25
			$("#p-size-display").val "#{(v + 0.1).toFixed(2).toString()} мм"
			$("input[name=p-size]").val v + 0.1
			modelParams.changeSize v + 0.1
			config.p1.size = v + 1

	$("#size a.minus").click ->
		v = parseFloat $("#p-size-display").val()
		if v > 10
			$("#p-size-display").val "#{(v - 0.1).toFixed(2).toString()} мм"
			$("input[name=p-size]").val v - 0.1
			modelParams.changeSize v-0.1
			config.p1.size = v - 1

	$("#p-size-display").on "change", ->
		v = parseFloat $("#p-size-display").val()
		if !Number.isNaN v
			if v >= 10 and v <= 25
				$("#p-size-display").val "#{v.toFixed(2).toString()} мм"
			else if v <= 10
				$("#p-size-display").val "10 мм"
			else if v >= 25
				$("#p-size-display").val "25 мм"
		else
			$("#p-size-display").val "18 мм"

		modelParams.changeSize parseFloat($("#p-size-display").val())
		$("input[name=p-size]").val parseFloat($("#p-size-display").val())

	$("input[name=p-size]").val config.p1.size

	$("#p-size-display").val "#{config.p1.size} мм"

	$("#slider").slider
		range: "min"
		value: config.p1.sizeDiamond
		min: 9.6
		max: 13.0
		step: 0.1
		slide: (event, ui) ->
			v = parseFloat ui.value
			$( "#amount" ).html "#{v.toFixed(2)} мм"
			$("input[name=p-size-diamond]").val v
			modelParams.changeSizeDiamond v

	$("#amount").html parseFloat($( "#slider" ).slider( "value" )).toFixed(2) + " мм"
	$("input[name=p-size-diamond]").val config.p1.sizeDiamond

	$('a.yearstyle').click ->
		$('.yearstyle').removeClass 'current'
		$(this).addClass 'current'

		modelParams.sizeDiamond = parseFloat $("#amount").html()
		diamondId = parseInt $(this).attr("data-obj")
		$("input[name=p-ring-diamond]").val diamondId
		modelParams.changeDiamondModel diamondId

	$(".ring_select").click ->
		modelParams.size = parseFloat $("#p-size-display").val()
		ringId = parseInt $(this).attr("data-obj")
		modelParams.changeRingModel ringId
		$("input[name=p-ring]").val ringId

	$("#height-ring").slider
	  range: "min"
	  value: config.p2.ringHeight
	  min: 1.5
	  max: 4
	  step: 0.1
	  slide: (event, ui) ->
	    v = parseFloat(ui.value)
	    $("#height-ring-display").html v.toFixed(2) + " мм"
	    modelParams.changeHeight v
	    $("input[name=p-height]").val v
	    return

	$("#height-ring-display").html config.p2.ringHeight.toFixed(2) + " мм"
	$("input[name=p-height]").val config.p2.ringHeight
	$("#thickness-ring").slider
	  range: "min"
	  value: config.p2.ringThickness
	  min: 1.5
	  max: 2.5
	  step: 0.1
	  slide: (event, ui) ->
	    v = parseFloat(ui.value)
	    $("#thickness-ring-display").html v.toFixed(2) + " мм"
	    modelParams.changeThickness v
	    return

	$("#thickness-ring-display").html config.p2.ringThickness.toFixed(2) + " мм"
	$("input[name=p-thickness]").val config.p2.ringThickness
	$("#height-text").slider
	  range: "min"
	  value: config.p2.fontHeight
	  min: 3
	  max: 6
	  step: 0.1
	  slide: (event, ui) ->
	    v = parseFloat(ui.value)
	    $("#height-text-display").html v.toFixed(2) + " мм"
	    modelParams.changeFontHeight v
	    $("input[name=p-text-height]").val v
	    return

	$("#height-text-display").html config.p2.fontHeight.toFixed(2) + " мм"
	$("input[name=p-text-height]").val config.p2.fontHeight
	$("#side-smooth").slider
	  range: "min"
	  value: config.p2.sideSmooth
	  min: 0
	  max: 1
	  step: 0.1
	  slide: (event, ui) ->
	    v = parseFloat(ui.value)
	    $("#side-smooth-display").html v.toFixed(2) + " мм"
	    modelParams.changeSideSmooth v
	    $("input[name=p-side-smooth]").val v
	    return

	$("#side-smooth-display").html config.p2.sideSmooth.toFixed(2) + " мм"
	$("input[name=p-side-smooth]").val config.p2.sideSmooth
	$("#font-select-list_SelectBoxItArrowContainer").click (e) ->
	  $("#font-select-list_SelectBoxItOptions").toggle()
	  e.stopPropagation()
	  return

	$("#symbol-select-list_SelectBoxItArrowContainer").click (e) ->
		$("#symbol-select-list_SelectBoxItOptions").toggle()
		e.stopPropagation()
		return

	###############################################################################################
	# Symbols initialization
	symbolGroups = [{
		name: 'Знаки зодиака',
		data: ["\uF0AD", "\uF0AE", "\uF0AF", "\uF0B0", "\uF0B1", "\uF0B2", "\uF0B3", "\uF0B4", "\uF0B5", "\uF0B6", "\uF0B7", "\uF0B8"]
	}, {
		name: 'Символы',
		data: [ "\uE001", "\uE002", "\uE003", "\uE004", "\uE005",
					 "\uE006", "\uE007", "\uE008", "\uE009", "\uE010",
					 "\uE011", "\uE012", "\uE013", "\uE016",
					 "\uE017", "\uE018", "\uE00A", "\uE00B", "\uE00C",
					 "\uE00D", "\uE00F", "\uE01A", "\uE01B", "\uE01D",
						"\uE01E", "\uE020", "\uE021", "\uE022", "\uE023",
						"\uE024", "\uE025", "\uE026", "\uE027", "\uE028",
						"\uE02A", "\uE02B", "\uE02C", "\uE02D",
						"\uE02E", "\uE02F", "\uF095", "\uF096", "\uF097"]
	}, {
		name: 'Цифры',
		data: ["\uF098", "\uF099", "\uF09A", "\uF09B", "\uF09C", "\uF09D", "\uF09E", "\uF09F", "\uF0A0",
					 "\uF0A1", "\uF0A2", "\uF0A3", "\uF0A4", "\uF0A5", "\uF0A6", "\uF0A7", "\uF0A8", "\uF0A9", "\uF0AA", "\uF0AB", "\uF0AC"]
	}];

	container = $('#symbol-select-list_SelectBoxItOptions').get(0);
	for group, i in symbolGroups
		ul = $('<div class="symbol-group-name">' + group.name + '</div><ul class="symbol-button-trigger-wrapper" id="group_' + i + '"></ul>');
		$(container).append(ul);

		for data, j in group.data
			li = $('<li class="symbol-button-trigger"></li>');
			$(container).find('ul#group_' + i).append(li);

			button = $('<button id="' + group.data[j] + '" type="button">' + group.data[j] + '</button>');
			$(li).append(button);

			$(button).click (elem) ->
				$('#text-input').val($('#text-input').val() + elem.target.getAttribute("id"));
				textMaxLength()

	$(":not(#font-select-list_SelectBoxItArrowContainer)").click (event) ->
	  $("#font-select-list_SelectBoxItOptions").hide()  unless $(event.target).is("#font-select-list_SelectBoxItOptions")
	  return

	$(":not(#symbol-select-list_SelectBoxItArrowContainer)").click (event) ->
		$("#symbol-select-list_SelectBoxItOptions").hide()  unless $(event.target).is("#symbol-select-list_SelectBoxItOptions")
		return

	$(".selectboxit-option").click ->
	  $(".selectboxit-focus").removeClass "selectboxit-focus"
	  $(this).addClass "selectboxit-focus"
	  text = $(this).attr('data-val')
	  modelParams.changeFont $('#text-input').val(), text.trim()
	  $("input[name=p-selected-font]").val text.trim()
	  return

	$("input[name=p-selected-font]").val config.p3.defaultFont

	if textMaxLength?
		$("#text-input").bind "input", textMaxLength

	setSelectionRange = (input, selectionStart, selectionEnd) ->
	  doGetCaretPosition = (oField) ->
	    # Initialize
	    iCaretPos = 0
	    # IE Support
	    if document.selection
	      # Set focus on the element
	      oField.focus()
	      # To get cursor position, get empty selection range
	      oSel = document.selection.createRange()
	      # Move selection start to 0 position
	      oSel.moveStart 'character', -oField.value.length
	      # The caret position is selection length
	      iCaretPos = oSel.text.length
	    else if oField.selectionStart or oField.selectionStart == '0'
	      iCaretPos = oField.selectionStart
	    # Return results
	    iCaretPos
	  start = input.selectionStart
	  end   = input.selectionEnd
	  if start != end then return
	  if input.setSelectionRange
	    input.focus()
	    input.setSelectionRange selectionStart, selectionEnd
	  else if input.createTextRange
	    range = input.createTextRange()
	    range.collapse true
	    range.moveEnd 'character', selectionEnd
	    range.moveStart 'character', selectionStart
	    range.select()
	  return

	$("#text-input").bind "keydown", ->
		setSelectionRange $(this)[0], $(this).val().length, $(this).val().length

	modelParams.price()

	# setTimeout (-> modelParams.changeFont $('#text-input').val()), 100
