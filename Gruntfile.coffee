###
# grunt-i18n
# https://github.com/SnijderC/grunt-i18n
#
# Copyright (c) 2017 Chris Snijder
# Licensed under the MIT license.
###

'use strict'

module.exports = (grunt) ->
  # Project configuration.
  grunt.initConfig
    clean:
      tests:
        [
          'test/actual/'
        ]
    i18n_pug:
      test:
        files: [{
          expand: true
          ext: '.html'
          cwd: './test/fixtures'
          src: [ '*.pug' ]
          dest: './test/actual/'
        }]
        options:
          pretty: true
          filters:
            all_caps: (data) ->
              return data.toUpperCase
          data:
            apples:
              type: 'tasty'
              num: 1
            pears:
              type: 'spoiled'
              num: 5
          i18n:
            locales: ['en', 'nl']
            #fallbacks:
              #nl: 'en'
            directory: './locales/'
            syncFiles: true
            updateFiles: true
            extension: ".yml"
    nodeunit:
      tests:
        [
          'test/*_test.coffee'
        ]
  # Actually load this plugin's task(s).
  grunt.loadTasks 'tasks'
  # These plugins provide necessary tasks.
  grunt.loadNpmTasks 'grunt-coffee-jshint'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-nodeunit'
  # Whenever the "test" task is run, first clean the "tmp" dir, then run this
  # plugin's task(s), then test the result.
  grunt.registerTask 'test', [
    'clean'
    'i18n_pug'
    'nodeunit'
  ]
  # By default, lint and run all tests.
  grunt.registerTask 'default', [
    'i18n_pug'
  ]
