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
						"coffee/_testing.coffee"
						"coffee/main.coffee" ]
					"../public/js/config.js": [ "coffee/config.coffee" ]

		# Минимикация скомпилированного файла кофе
		uglify:
			options:
				beautify: true
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
					'../public/panels/p0.html': 'panels/p0.html'
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
