#global module:false

"use strict"

module.exports = (grunt) ->
  grunt.loadNpmTasks "grunt-bower-task"
  grunt.loadNpmTasks "grunt-contrib-connect"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-exec"

  grunt.initConfig

    clean:
      dist:
        src: [
          "_site"
          "vendor"
        ]

    copy:
      jquery:
        files: [{
          expand: true
          cwd: "bower_components/jquery/dist/"
          src: "jquery.min.js"
          dest: "vendor/js/"
        }]
      bootstrap:
        files: [{
            expand: true
            cwd: "bower_components/bootstrap/dist/js/"
            src: "bootstrap.min.js"
            dest: "vendor/js/"
          },
          {
            expand: true
            cwd: "bower_components/bootstrap/scss/"
            src: "**/*.scss"
            dest: "_sass/vendor/bootstrap/"
          }]
      fontawesome:
        files: [{
            expand: true
            cwd: "bower_components/components-font-awesome/css/"
            src: "font-awesome.min.css"
            dest: "vendor/css/"
          },
          {
            expand: true
            cwd: "bower_components/components-font-awesome/fonts/"
            src: "*"
            dest: "vendor/fonts/"
            filter: "isFile"
          }]

    exec:
      jekyll:
        cmd: "jekyll build --trace --config _config.yml,_config.dev.yml"

    watch:
      options:
        livereload: true
      source:
        files: [
          "_drafts/**/*"
          "_includes/**/*"
          "_layouts/**/*"
          "_posts/**/*"
          "_sass/**/*"
          "css/**/*"
          "js/**/*"
          "_config.yml"
          "*.html"
          "*.md"
        ]
        tasks: [
          "exec:jekyll"
        ]

    connect:
      server:
        options:
          host: 'localhost'
          port: 4000
          base: '_site'
          livereload: true


  grunt.registerTask "build", [
    "clean:dist"
    "copy"
    "exec:jekyll"
  ]

  grunt.registerTask "serve", [
    "build"
    "connect:server"
    "watch"
  ]

  grunt.registerTask "default", [
    "serve"
  ]
