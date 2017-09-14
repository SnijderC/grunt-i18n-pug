'use strict'

grunt = require 'grunt'

###
    ======== A Handy Little Nodeunit Reference ========
    https://github.com/caolan/nodeunit

    Test methods:
        test.expect(numAssertions)
        test.done()
    Test assertions:
        test.ok(value, [message])
        test.equal(actual, expected, [message])
        test.notEqual(actual, expected, [message])
        test.deepEqual(actual, expected, [message])
        test.notDeepEqual(actual, expected, [message])
        test.strictEqual(actual, expected, [message])
        test.notStrictEqual(actual, expected, [message])
        test.throws(block, [error], [message])
        test.doesNotThrow(block, [error], [message])
        test.ifError(value)
###

exports.i18n_pug = {
    setUp: (done) ->
        # setup here if necessary
        done()

    default_locale: (test) ->
        test.expect 1
        actual = grunt.file.read 'test/actual/en/test.html'
        expected = grunt.file.read 'test/expected/en/test.html'
        expected = expected.replace(/\n$/g, '')
        test.equal(
            actual,
            expected,
            'Generated HTML file should be the same as test/expected/test.html'
        )
        test.done()

    other_locale: (test) ->
        test.expect 1
        actual = grunt.file.read 'test/actual/nl/test.html'
        expected = grunt.file.read 'test/expected/nl/test.html'
        expected = expected.replace(/\n$/g, '')
        test.equal(
            actual,
            expected,
            'Generated HTML file should be the same as test/expected/test.html'
        )
        test.done()
}
