###
grunt-i18n-pug
https://github.com/SnijderC/grunt-i18n-pug

Copyright (c) 2017 Chris Snijder
Licensed under the MIT license.
###
'use strict'
module.exports = (grunt) -> grunt.registerMultiTask(
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

        config = {}
        config.options = @options()

        if not config.options.i18n?
            err = new Error(
                'You need to configure an `i18n` object in your target'+
                ' options. See here: https://github.com/SnijderC/'+
                'grunt-i18n-pug/blob/master/README.md'
            )
            grunt.fail.fatal err

        escapeSignificantChars = (data, reverse=false) ->
            if !reverse
                data.replace(/\|/g, '%%PIPE%%')
            else
                data.replace('%%PIPE%%', '|')

        gettextFilter = (context) ->
            (text, options, noEscape=false) ->
                if !noEscape
                    text = escapeSignificantChars(text)
                if options.vars?
                    data = context.__(text, options.vars...)
                else
                    data = context.__(text)
                if !noEscape
                    data = escapeSignificantChars(data, true)
                data

        gettextFilterN = (context) ->
            (text, options) ->
                single = /^(.+?)\n\s*?N:\s/g.exec(text)
                plural = /\n\s*?N:\s(.*)$/g.exec(text)
                if single? and plural?
                    context.__n(single[1], plural[1], options.num)
                else
                    text = text.replace(/\n/g, "\\n")
                    grunt.fail.warn(
                        "Filter input \"#{text}\" in file " +
                        "#{options.filename} is formatted incorrectly."
                    )

        gettextFilterMf = (context) ->
            (text, options) ->
                if _.size(options)
                    if options.vars?
                        vars = options.vars
                        delete options.vars
                        return context.__mf(text, vars, options)
                    return context.__mf(text, options)
                return context.__mf(text)

        # Get raw config (unparsed configuration)
        config.files = grunt.config.getRaw(
            # Most commonly `i18n_pug.[target]` or `i18n_pug`
            if @target.length then "#{@name}.#{@target}" else @name
        ).files

        # Set files[n].orig for each files object
        for file_obj, key in config.files
            config.files[key] = file_obj.orig || file_obj

        # Find the i18n settings object in the options and preserve it
        i18nConfig = config.options.i18n
        # Remove options not supported by grunt-contrib-pug from config
        delete config.options.i18n
        # See if we should rename the files to:
        #  - [dest][filename]_[locale].[ext] - or
        #  - [dest]/[locale]/[filename].[ext] - or
        rename = config.options.rename ? 'dir'
        delete config.options.rename if config.options.rename?

        # Preserve any rename functions passed to the file object
        if rename
            callbacks = {}
            for files, key in config.files
                callbacks[key] = (src, dest) ->
                    "#{src}#{dest}"
                if config.files[key].rename?
                    if typeof config.files[key].rename is 'function'
                        callbacks[key] = config.files[key].rename
        tasks = 0
        for locale in i18nConfig.locales
            # Make a duplicate of config (i.e. not byref)
            _config = _.cloneDeep(config)
            _config.options._i18n = {}
            # Register __(), __n(), etc. in pugs data namespace
            i18nConfig.register = _config.options._i18n
            # Configure i18n
            i18n.configure i18nConfig
            # Set the locale
            _config.options._i18n.setLocale locale
            if typeof _config.options.data != 'function'
                _.assign(_config.options.data, _config.options._i18n)
                delete _config.options._i18n
            else
                data_callback = _config.options.data

                _config.options.data = (
                    (data_obj) ->
                        (src, dest) ->
                            data = data_callback(src, dest)
                            _.assign(data, data_obj._i18n)
                            delete data_obj._i18n
                            data
                )(_config.options)

            # add a gettext filter
            _config.options.filters ?= {}
            _.assign _config.options.filters, {
                __: gettextFilter _config.options.data
                __n: gettextFilterN _config.options.data
                __mf: gettextFilterMf _config.options.data
            }

            # Add a rename function to the files attribute of the task to
            # add the locale in the name.
            if rename
                for files, key in config.files
                    do (files, key, locale) -> # preserve for-loop indexes
                        ext = files.ext
                        _config.files[key].rename = (src, dest) ->
                            if rename == 'file'
                                dest = dest.slice(0,-ext.length)
                                dest += "_#{locale}#{ext}"
                            else if rename == 'dir'
                                dest = "#{locale}/#{dest}"
                            # Run callback if any
                            return callbacks[key] src, dest
            target = if @target then "#{@target}_#{locale}" else locale
            grunt.config.set "pug.#{target}", _config
            grunt.task.run ["pug:#{target}"]
            tasks++

        ptasks = grunt.util.pluralize tasks, 'task/tasks'
        grunt.log.ok (
            "Added #{tasks} grunt-contrib-pug #{ptasks}."
        )

)
