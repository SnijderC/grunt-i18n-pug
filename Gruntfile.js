/*
 * grunt-i18n
 * https://github.com/SnijderC/grunt-i18n
 *
 * Copyright (c) 2017 Chris Snijder
 * Licensed under the MIT license.
 */

'use strict';

module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    jshint: {
      all: [
        'Gruntfile.js',
        'tasks/*.js',
        '<%= nodeunit.tests %>'
      ],
      options: {
        jshintrc: '.jshintrc'
      }
    },

    // Before generating any new files, remove any previously-created files.
    clean: {
      tests: ['tmp']
    },

    // Configuration to be run (and then tested).
    i18n_pug: {
      test: {
        pug: {
          options: {
            pretty: true,
            data: {
                apples: {
                    type: 'tasty',
                    num: 1
                },
                pears: {
                    type: 'spoiled',
                    num: 5
                }
            }
          },
          files: [{
            expand: true
            ext: '.html'
            cwd: './src'
            src: [
              '*.pug'
            ]
            dest: './test/expected/'
          }]
        },
        i18n: {
          locales:['en', 'nl'],
          directory: './locales/'
        }
      }
    },
    // Unit tests.
    nodeunit: {
      tests: ['test/*_test.js']
    }

  });

  // Actually load this plugin's task(s).
  grunt.loadTasks('tasks');

  // These plugins provide necessary tasks.
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-nodeunit');

  // Whenever the "test" task is run, first clean the "tmp" dir, then run this
  // plugin's task(s), then test the result.
  grunt.registerTask('test', ['clean', 'i18n_pug:test', 'nodeunit']);

  // By default, lint and run all tests.
  grunt.registerTask('default', ['jshint', 'test']);

};
