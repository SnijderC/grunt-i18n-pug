# grunt-i18n-pug

> Wrapper for mashpie's i18n-node.

## Getting Started
This plugin requires Grunt `~0.4.5`

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins. Once you're familiar with that process, you may install this plugin with this command:

```shell
npm install grunt-i18n-pug --save-dev
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-i18n-pug');
```

## The "i18n_pug" task

### Overview
In your project's Gruntfile, add a section named `i18n_pug` to the data object passed into `grunt.initConfig()`.

```js
grunt.initConfig({
  i18n_pug: {
    your_target: {
      // See Usage examples below.
    },
  },
});
```

### Options

Additional options are explained below.

#### options.pug
Type: `Object`
Default value: `{}`

This object will be passed on to [`grunt-contrib-pug`](https://www.npmjs.com/package/grunt-contrib-pug).

#### options.i18n
Type: `Object`
Default value: `{}`

This object will be passed on to [`node-i18n`](https://www.npmjs.com/package/i18n).

### Usage Examples

```js
grunt.initConfig({
  i18n_pug: {
    your_target: {
      pug: {
        options: {
          pretty: true,
          data: {
              hello: '__("Hello world!")'
          }
        },
        files: [{
          expand: true
          ext: '.html'
          cwd: './src'
          src: [
            '*.pug'
          ]
          dest: './build/'
        }]
      },
      i18n: {
        locales:['en', 'de'],
        directory: './locales/'
      }
    }
  }
});
```
