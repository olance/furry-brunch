exports.config =
# See docs at https://github.com/brunch/brunch/blob/master/docs/config.md
  coffeelint:
    pattern: /^app\/.*\.coffee$/
    options:
      indentation:
        value: 2
        level: "error"
                      
  files:
    javascripts:
      joinTo:
        'javascripts/app.js': /^app/
        'javascripts/vendor.js': /^vendor/
        
      order:
      # Files in `vendor` directories are compiled before other files
      # even if they aren't specified in order.
        before: [
          'vendor/scripts/jquery.js'
          'vendor/scripts/json2.js'
          'vendor/scripts/lodash.js'
          'vendor/scripts/backbone.js',
          'vendor/scripts/backbone-mediator.js'
        ]

    stylesheets:
      joinTo: 'stylesheets/app.css'
      order:
        before: ['vendor/styles/normalize.css']
        after: ['vendor/styles/helpers.css']

    templates:
      joinTo: 'javascripts/app.js'
