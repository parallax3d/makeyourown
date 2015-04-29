formPost = "post_test.php"

config =
	p0: # Font testing
		title: "Тестировщик шрифтов"
		id: "p0"
		menuIcon: "css/icons/product1.png"
		model: Testing
		defaultFont: ""
		fonts: []
		height: "250px"
		price: (obj) ->
			return 5000
	p1:
		title: "Diamond Ring"
		id: "p1"
		size: 18
		sizeDiamond: 11
		menuIcon: "css/icons/product1.png"
		model: DiamondRing
		defaultFont: ""
		fonts: []
		height: "420px"
		price: (obj) ->
			return 5000
	p2:
		title: "M-Ring"
		id: "p2"
		menuIcon: "css/icons/product2.png"
		defaultFont: "arian amu"
		model: ConvexTextRing
		size: 18
		maxTextLength: 11
		ringHeight: 2.5
		ringThickness: 2
		fontHeight: 4
		sideSmooth: 0.5
		height: "525px"
		price: (obj) ->
			return 5000
		fonts: [
			"arian amu"
			"red october"
			"fha nicholson french ncv"
			"american captain"
			"scada"
		]
	p3:
		title: "Messager"
		id: "p3"
		size: 18
		menuIcon: "css/icons/product4.png"
		defaultFont: "arian amu"
		model: Messager
		maxTextLength: 6
		height: "280px"
		price: (obj) ->
			return 5000
		fonts: [
			"arian amu"
		]
	p4:
		title: "One’s Necklace"
		id: "p4"
		menuIcon: "css/icons/product5.png"
		defaultFont: "calligraph"
		model: Necklace
		maxTextLength: 15
		height: "220px"
		price: ->
			return 0
		fonts: [ "calligraph", "Damion", "Harlow", "Molle", "Norican", "Script", "Segoe", "icomoon", "Yellowtail",	"nickainley",  "veryberry", "goodvibes"]
	p5:
		title: "Raw"
		id: "p5"
		menuIcon: "css/icons/product6.png"
		defaultFont: "aldrich"
		model: Raw
		maxTextLength: 8
		latinFont: "aldrich"
		cyrillicFont: "scada"
		size: 18
		height: "280px"
		price: (obj) ->
			return 5000
		fonts: [ "scada", "aldrich" ]
	p6:
		title: "Raw-Round"
		id: "p6"
		menuIcon: "css/icons/product7.png"
		defaultFont: "calligraph"
		model: RawRound
		maxTextLength: 15
		size: 18
		height: "280px"
		price: ->
			return 0
		fonts: [ "calligraph", "Damion", "Harlow", "Molle", "Norican", "Script", "Segoe", "icomoon", "Yellowtail", "nickainley", "veryberry", "goodvibes"]
	p7:
		title: "Cufflink"
		id: "p7"
		menuIcon: "css/icons/product8.png"
		defaultFont: "calligraph"
		model: Cufflink
		maxTextLength: 15
		size: 18
		height: "280px"
		price: ->
			return 0
		fonts: [ "calligraph", "Damion", "Harlow", "Molle", "Norican", "Script", "Segoe", "icomoon", "Yellowtail", "nickainley", "veryberry", "goodvibes"]