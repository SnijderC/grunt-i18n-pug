# grunt-i18n-pug
> Wrapper for mashpie's using [node-i18n][ni18n] within pug templates.

### NOTE: THIS IS NOT PRODUCTION READY
#### Possible side-effects: 
 - Temporary/__permanent__ loss of sanity
 - Hair loss *if any*

#### Use at your own risk, you've been warned!

## What is this?

This is basically a wrapper around 2 existing projects: [grunt-contrib-pug][gcp] and [node-i18n][ni18n]. When configured as explained below, you can define pug templates like so:

``` jade
doctype html
html
  head
    meta(charset="utf-8")
    title= __("Test page")
  body
    h1
      = __("Localised versions of")
      |  #[code test.pug]
    p Locale: "#{locale}"
    h2= __("Working with filters")
    p
      :__ 
        Fruits are often tasty.
    p
      :__(vars=["Jim"])
        %s's pears usually tasty.
    p
      :__mf(foo="Frank")
        {foo}'s apples are usually tasty too.
    p
      :__mf(vars=["Jim"], dude="Frank")
        Comparing %s's apples and {dude}'s pears is not fair.
    p
      :__n(num=1)
        %s pear is just one..
        N: %s pears is better than 1
    p
      :__n(num=2)
        %s pear is ok
        N: %s pears is better than 1
    h2= __("Working with javascript functions")
    ul
      li= __n("Number of apples: ") + apples.num
      li= __n("Number of pears: ") + pears.num
    p=__n("What would you say if I gave you %s %%s apple?", "What would you say if I gave you %s %%s apples?", apples.num, __(apples.type))
    p=__n("What would you say if I gave you %s %%s pears?", "What would you say if I gave you %s %%s pears?", pears.num, __(pears.type))
```

Which will compile to:

``` html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Test page</title>
  </head>
  <body>
    <h1>Localised versions of <code>test.pug</code>
    </h1>
    <p>Locale: "en"</p>
    <h2>Working with filters</h2>
    <p>Fruits are often tasty.</p>
    <p>Jim's pears usually tasty.</p>
    <p>Frank's apples are usually tasty too.</p>
    <p>Comparing Jim's apples and Frank's pears is not fair.</p>
    <p>1 pear is just one..</p>
    <p>2 pears is better than 1</p>
    <h2>Working with javascript functions</h2>
    <ul>
      <li>Number of apples: 1</li>
      <li>Number of pears: 5</li>
    </ul>
    <p>What would you say if I gave you 1 tasty apple?</p>
    <p>What would you say if I gave you 5 spoiled pears?</p>
  </body>
</html>

```

__or__:

``` html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Test pagina</title>
  </head>
  <body>
    <h1>Gelocaliseerde versie van <code>test.pug</code>
    </h1>
    <p>Locale: "nl"</p>
    <h2>Werken met filters</h2>
    <p>Fruit is vaak lekker.</p>
    <p>Jims peren zijn meestal lekker.</p>
    <p>Franks appels zijn meestal ook wel lekker.</p>
    <p>Jims appels vergelijken met Franks peren is niet eerlijk.</p>
    <p>1 peer is er maar een..</p>
    <p>2 peren is beter dan 1</p>
    <h2>Met javascript functies werken</h2>
    <ul>
      <li>Aantal appels: 1</li>
      <li>Aantal peren: 5</li>
    </ul>
    <p>Wat zou je ervan vinden als ik je 1 smakelijke appel gaf?</p>
    <p>Wat zou je ervan vinden als ik je 5 bedorven peren gaf?</p>
  </body>
</html>
```

Note that filters are executed at compile time, which means you can't mix in a javascript call with them, which is unfortunate.

You can nest calls to `__()` but you should not do this:

``` pug
- var stringType = "simple";
//- THIS IS BAD!
= __(__("I want to localise this %s string."), stringType)
```

Because it will lead to 2 similar strings in your localisation files:

``` json
"I want to localise this %s string.": "I want to localise this %s string."
"I want to localise this simple string.": "I want to localise this simple string."
```

Instead do this:
``` pug
- var stringType = "simple";
//- This is OK
= __("I want to localise this %s string.", __(stringType))
```

Now we will get this in the localisation file:
``` json
"I want to localise this %s string.": "I want to localise this %s string."
"simple": "simple"
""
```

Also note that when we use variables, all possible values of `stringType` should be in the localisation file. Since they are added automatically, this will only happen when we come across them, so add them manually.

## Getting Started

Read the [note](#note-this-is-not-production-ready) above first.

This is a [grunt][g] plugin for grunt versions `0.4.5` and up.

Read the usual [grunt][g] instructions here: [Getting Started](http://gruntjs.com/getting-started)

### Installing

Use [yarn][y] it will make your already though life – since you apparently have to work with [Node][n] and [grunt][g], a little easier.

```shell
yarn add grunt-i18n-pug --save
```

If you don't want to work with [yarn][y]:

```shell
npm install grunt-i18n-pug --save
```

### Applying the wrapper

Once the plugin has been installed, it may be enabled inside your [Gruntfile](https://gruntjs.com/sample-gruntfile) with this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-i18n-pug');
```

### How does it work?

When working with [grunt-contrib-pug][gcp], you would add a task named `pug` to your Gruntfile. To use this plugin you will have to rename it to: `i18n_pug`. Your targets don't need any changes. Most of the configuration is the same as [grunt-contrib-pug's][gcp].

However, your renamed configuration should at minimum have one extra object within the `options` object (task and/or target level): `i18n`. This will hold pretty much all the settings [node-i18n][ni18n] supports, like: 
 - `locales`
 - `api`
 - `extension`
 - `directory`
 - `directoryPermissions`
 - `updateFiles`
 - `syncFiles`
 - `defaultLocale`
 - `fallbacks`

But not these, since they are either for use in [Node][n] apps or they conflict with the wrapper: 
 - `register` – this will be overridden to tie the [node-i18n][ni18n] api to the `data` object that is passed to the pug templates.
 - `autoReload` - i18n will not run the show, so this can't happen, see [grunt-contrib-watch](https://www.npmjs.com/package/grunt-contrib-watch) instead.  
 - `queryParameter` - Node app option
 - `cookie` - Node app option

When the wrapper is run the following happens:
 
 1. For every task/target a `grunt-contrib-pug` task is created.
 
 2. The new task will receive the `i18n_pug` task/target configuration stripped of wrapper specific attributes. This means you can use all the usual [grunt][g] attributes like: [`files`][gfiles] (required), [`options`][goptions] (required) as well as [grunt-contrib-pug's][gcp]: [`filters`](https://www.npmjs.com/package/grunt-contrib-pug#filters) (optional), [`data`](https://www.npmjs.com/package/grunt-contrib-pug#data), etc.
 
 3. Once configured, the wrapper will iterate over the `locales` array configured in `i18n_pug.options.i18n` and duplicate the configuration for each locale.

 4. The wrapper adds the `grunt-contrib-pug` tasks to be run after the wrapper
 finishes.

 5. Grunt will run the configured tasks and save the generated files according to the `rename` option (see below), wich defaults to `[files.src]/[locale]/[files.dest]`, e.g. `build/en_GB/index.html`.


## The "i18n_pug" task

### Overview
In your project's Gruntfile, add a section named `i18n_pug` to the data object passed into `grunt.initConfig()` or change your exsiting `pug` task(s) to `i18n_pug`.

```js
grunt.initConfig({
  i18n_pug: {
    your_target_name_here: {
      // See Usage examples below.
    },
  },
});
```

### Options

Additional options are explained below.

Your target/task should at minimum have the following objects:

 - `files` as defined in the [Grunt configuring tasks - files section][gfiles]
 - `options` as defined in the [Grunt configuring tasks - options section][goptions]

#### options.i18n (required)
Type: `Object`
Default value: `{}`

This object will be passed on to [`node-i18n`](https://www.npmjs.com/package/i18n). See [How does it work?](#how-does-it-work) for more information.

### Usage Examples

```js
grunt.initConfig({
  i18n_pug: {
    your_target_name_here: {
      files: [
        {
          expand: true,
          ext: '.html',
          cwd: './src/',
          src: ['*.pug', '**/*.pug'],
          dest: './test/actual/'
        }
      ],
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
        },
        i18n: {
          locales: ['en', 'nl'],
          directory: './locales/',
          syncFiles: true
          updateFiles: true
        }
      }
    }
  }
});
```

## TODO

Parse pug files before compilation and replace calls before compiling, this will allow a lot more flexible calls within pug templates.


[y]:  https://yarnpkg.com/ "“Fast, reliable, and secure dependency management”"
[g]: https://gruntjs.com/ "“The JavaScript Task Runner”"
[gcp]: https://www.npmjs.com/package/grunt-contrib-pug
[ni18n]: https://github.com/mashpie/i18n-node
[n]: https://nodejs.org
[gfiles]: https://gruntjs.com/configuring-tasks#files
[goptions]: https://gruntjs.com/configuring-tasks#options
