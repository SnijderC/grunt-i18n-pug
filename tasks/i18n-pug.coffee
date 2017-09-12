###
grunt-i18n-pug
https://github.com/SnijderC/grunt-i18n-pug

Copyright (c) 2017 Chris Snijder
Licensed under the MIT license.
###

'use strict';

module.exports = (grunt) ->

    requirements = [
        'grunt-contrib-pug'
    ]

    grunt.registerMultiTask 'i18n_pug', 'Wrapper for mashpie\'s i18n-node.', ->

        missing_reqs = []
        for requirement in requirements
            try
                require requirement
                grunt.loadNpmTasks requirement
            catch e
                missing_reqs.push requirement
        if missing_reqs.length
            err = new Error(
                'Dependencies are not installed: '+
                missing_reqs.join(", ")
            )
            err.origError = e;
            grunt.fail.warn(err);

    @requiresConfig ['pug', 'i18n']

    # Merge task-specific and/or target-specific options for pug and i18n.
    options = @options()

    # Iterate over all specified file groups.
    @files.forEach (f) ->
      # Concat specified files.
      src = f.src.filter((filepath) ->
        # Warn on and remove invalid source files (if nonull was set).
        if !grunt.file.exists(filepath)
          grunt.log.warn 'Source file "' + filepath + '" not found.'
          false
        else
          true
      ).map((filepath) ->
        # Read file source.
        grunt.file.read filepath
      ).join(grunt.util.normalizelf(options.separator))
      # Handle options.
      src += options.punctuation
      # Write the destination file.
      grunt.file.write f.dest, src
      # Print a success message.
      grunt.log.writeln 'File "' + f.dest + '" created.'
