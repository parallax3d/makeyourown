# Конфигурационный файл для Grunt'а
# Анонимная функция
module.exports = (grunt) ->
	# Инициализация конфигурации грунта
	grunt.initConfig
	 	# Компиляция кофе
		coffee:
			compileBare:
				options:
					bare: true
				files:
					"../public/js/main.js": [ "coffee/_ConvexTextRing.coffee"
						"coffee/__necklace-text.coffee"
						"coffee/__text.coffee"
						"coffee/_diamondring.coffee"
						"coffee/_messager.coffee"
						"coffee/_necklace.coffee"
						"coffee/_raw.coffee"
						"coffee/graphics.coffee"
						"coffee/_rawround.coffee"
						"coffee/_cufflink.coffee"
						"coffee/main.coffee" ]
					"../public/js/config.js": [ "coffee/config.coffee" ]

		# Минимикация скомпилированного файла кофе
		uglify:
			options:
				# beautify: true
				mangle: true
				compress:
					drop_console  : false
					sequences     : true  # join consecutive statemets with the “comma operator”
					properties    : true  # optimize property access: a["foo"] → a.foo
					dead_code     : true  # discard unreachable code
					drop_debugger : true  # discard “debugger” statements
					unsafe        : true # some unsafe optimizations (see below)
					conditionals  : true  # optimize if-s and conditional expressions
					comparisons   : true  # optimize comparisons
					evaluate      : true  # evaluate constant expressions
					booleans      : true  # optimize boolean expressions
					loops         : true  # optimize loops
					unused        : true  # drop unused variables/functions
					hoist_funs    : true  # hoist function declarations
					hoist_vars    : true  # hoist variable declarations
					if_return     : true  # optimize if-s followed by return/continue
					join_vars     : true  # join var declarations
					cascade       : true  # try to cascade `right` into `left` in sequences
					side_effects  : true  # drop side-effect-free statements
					warnings      : false  # warn about potentially dangerous optimizations/code
				codegen:
					quote_keys    : true # quote all keys in object literals?
					space_colon   : false  # add a space after colon signs?
					ascii_only    : true # output ASCII-safe? (encodes Unicode characters as ASCII)
					inline_script : true # escape "</script"?
					ie_proof      : true  # output IE-safe code?
					bracketize    : false # use brackets every time?
					comments      : false # output comments?
					semicolons    : false  # use semicolons to separate statements? (otherwise, newlines)
			main:
				src: ['../public/js/main.js']
				dest: '../public/js/main.js'

		# Отслеживание изменений и перекомпиляция
		watch:
			html:
				files: ['*.html', "panels/*.html"]
				tasks: ['htmlmin']
				options:
					spawn: false
					debounceDelay: 250
					livereload: true
			css:
				files: ['css/*.css']
				tasks: ['cssmin']
				options:
					spawn: false
					debounceDelay: 250
					livereload: true
			coffee:
				files: ['coffee/*.coffee']
				tasks: ['coffee', 'uglify:main']
				options:
					spawn: false
					debounceDelay: 250
					livereload: true
			configFiles:
				files: ['Gruntfile.coffee']
				tasks: ['coffee']
				options:
					reload: true

		htmlmin:
			dist:
				options:
					removeOptionalTags: true
					removeEmptyAttributes: true
					removeRedundantAttributes: true
					removeAttributeQuotes: true
					collapseBooleanAttributes: true
					removeCDATASectionsFromCDATA: true
					removeCommentsFromCDATA: true
					removeComments: true
					collapseWhitespace: true
				files:
					'../public/index.html': 'index.html'
					'../public/panels/p1.html': 'panels/p1.html'
					'../public/panels/p2.html': 'panels/p2.html'
					'../public/panels/p3.html': 'panels/p3.html'
					'../public/panels/p4.html': 'panels/p4.html'
					'../public/panels/p5.html': 'panels/p5.html'
					'../public/panels/p6.html': 'panels/p6.html'
					'../public/panels/p7.html': 'panels/p7.html'
		cssmin:
			minify:
				expand: true,
				cwd: 'css/',
				src: ['*.css', '!*.min.css', '!out.css'],
				dest: '../public/css/',
				ext: '.min.css'

	# Загрузка задач
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-uglify'
	grunt.loadNpmTasks 'grunt-contrib-htmlmin'
	grunt.loadNpmTasks 'grunt-contrib-cssmin'


	# Регистрация дефолтной задачи, чтобы можно было вызывать $ grunt
	grunt.registerTask 'default', ['watch']
