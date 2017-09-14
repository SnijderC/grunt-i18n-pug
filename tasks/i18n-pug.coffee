###
grunt-i18n-pug
https://github.com/SnijderC/grunt-i18n-pug

Copyright (c) 2017 Chris Snijder
Licensed under the MIT license.
###
'use strict'
module.exports = (grunt) ->

    grunt.registerMultiTask(
        'i18n_pug',
        'Wrapper for mashpie\'s i18n-node in grunt-contrib-pug.',
        () ->
            try
                _ = require 'lodash'
                i18n = require 'i18n'
                grunt.loadNpmTasks 'grunt-contrib-pug'
            catch e
                err = new Error(
                    'Missing dependencies, need: lodash, node-i18n and'+
                    'grunt-contrib-pug.'
                )
                err.origError = e
                grunt.fail.warn err

            if not 'i18n' of @options
                err = new Error(
                    'You need to configure an `i18n` object in your target'+
                    ' options.'
                )
                grunt.fail.warn err

            # Get raw config (unparsed configuration)
            config = grunt.config.getRaw(
                @name + if @target then "." + @target else ''
            )

            # Find the i18n settings object in the options
            i18nConfig = config.options.i18n
            # Remove options not supported by grunt-contrib-pug
            delete config.options.i18n
            # Register __(), __n(), etc. in pugs data namespace
            i18nConfig.register = config.options.data
            # Configure i18n
            i18n.configure i18nConfig
            # See if we should rename the files to:
            # [dest][filename]_[locale].[ext]
            rename = config.options.rename ? 'dir'
            delete config.options.rename if config.options.rename?
            # Preserve any rename functions passed to the file object
            if rename
                callbacks = {}
                for files, key in config.files
                    if typeof config.files[key].rename is 'function'
                        callbacks[key] = config.files[key].rename
                    else
                        callbacks[key] = (src, dest) ->
                            "#{src}#{dest}"

            for locale in i18nConfig.locales
                # Add a rename function to the files attribute of the task to
                # add the locale in the name.
                if rename
                    for files, key in config.files
                        do (files, key, locale) ->
                            ext = files.ext
                            config.files[key].rename = (src, dest) ->
                                if rename == 'file'
                                    dest = dest.slice(0,-ext.length)
                                    dest += "_#{locale}#{ext}"
                                else if rename == 'dir'
                                    dest = "#{locale}/#{dest}"
                                # Run callback if any
                                return callbacks[key] src, dest
                            config.options.data.setLocale(locale)

                target = if @target then "#{@target}_#{locale}" else locale
                grunt.config.set "pug.#{target}", _.cloneDeep(config)
                grunt.task.run ["pug:#{target}"]
    )
