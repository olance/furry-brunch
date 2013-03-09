## Cake tasks
#
#### Build
# ```cake build```: Build sources using brunch  
#
#### Test
# ```cake test```: Rebuild everything and run tests
#
# ***options***:  
# -w, --watch: Use this option to keep CoffeeScript/Brunch on, watching changes and rebuilding sources or specs on the
# go
#
#### Documentation
# ```cake doc:build```: Build documentation pages from sources
#
# Documentation files are generated for:
#
#   * This Cakefile
#   * The app source files under *app/*
#   * Spec source files under *spec/*
#
# You can generate docs for these elements independently using the following commands (respectively):
#
#   * ```cake doc:build:cakefile```
#   * ```cake doc:build:app```
#   * ```cake doc:build:specs```
#
# -------------

# Get handles to some useful commands
fs   = require 'fs'
{walk} = require 'walk'
path = require 'path'
{spawn, exec} = require 'child_process'

# -------------
# # Build app sources

# As we are using Brunch to manage the app sources/structure, just delegate the build to *brunch build*
build = (callback) ->
  exec 'brunch build', (err, stdout, stderr) ->
    throw err if err
    console.log stdout, stderr

    callback?()

task 'build', 'Build sources using brunch', ->
  build()


# -------------  
# # Build and run tests

# Define watch option
option '-w', '--watch', 'Use this option to keep CoffeeScript on, watching changes to specs'


# Tests are written in CoffeeScript using the Jasmine framework.
# Use this task to compile the tests and start the Spec Runner. You can pass the -w/--watch option to keep CoffeeScript
# watching for changes to the sources/spec and rebuild as necessary.
task 'test', 'Rebuild and run tests', (options) ->
  watch = options.watch

  # Prepare arguments to coffee (adding -w if necessary)
  args    = ['-c', '-o', 'spec', '-j', 'specs', 'spec']
  args[0] = '-cw' if watch

  # Spwan watchers if we're watching, otherwise simply build specs
  if watch
    #### Brunch watcher (App sources)
    brunch_watcher = spawn 'brunch', ['watch']

    # Bind stdout/stderr to console output
    brunch_watcher.stdout.on 'data', (data) ->
      console.log data.toString().trim()

    brunch_watcher.stderr.on 'data', (data) ->
      console.log data.toString().trim()


    #### CoffeeScript watcher (specs)
    coffee_watcher = spawn 'coffee', args

    # Bind stdout/stderr to console output
    coffee_watcher.stdout.on 'data', (data) ->
      console.log data.toString().trim()

    coffee_watcher.stderr.on 'data', (data) ->
      console.log data.toString().trim()

    # Open the spec runner now, refresh of the web page might be necessary as we don't know when the scripts will be
    # built
    exec 'open spec/SpecRunner.html'

  else
    # Build sources, then specs, and print outputs
    build ->
      exec "coffee #{args.join(' ')}", (err, stdout, stderr) ->
        throw err if err
        console.log stdout, stderr

        # Open the spec runner after the specs have been built
        exec 'open spec/SpecRunner.html'


# -------------
# # Build the documentation files

# This function invokes the ```docco``` command with given arguments and calls back ```callback``` when the execution is
# finished.
docco = (callback, args...) ->
  exec "docco #{args.join(' ')}", (err, stdout, stderr) ->
    throw err if err
    console.log(stdout, stderr)
    
    callback?()

# Find all files with given extensions recursively in ```dir``` directory and call ```callback``` with an array of found
# files when it's done.
walkDir = (callback, dir, extensions...) ->
  walkDir.lock = true
  files = []
  walker = walk(dir, followLinks: false)
  
  # When a file has been found...
  walker.on 'file', (root, stat, next) ->
    # Check its extension and add it to the list if it matches given extensions
    ext = path.extname(stat.name)
    files.push(path.join(root, stat.name)) if ext in extensions
    
    next()
        
  # When we have finished walking the directory...
  walker.on 'end', ->
    walkDir.lock = false
    # Send the files list to the callback 
    callback?(files)
  
  true
  
    
# ## Generate Cakefile documentation 

task 'doc:build:cakefile', 'Build documentation files for the Cakefile file', ->
  
  # Copy Cakefile to Cakefile.coffee so that docco recognizes it
  fs.createReadStream('Cakefile').pipe(fs.createWriteStream('Cakefile.coffee'))
      # Wait for copy completion
      .on 'close', ->
        console.log("### Generate Cakefile documentation")
        
        # Run Docco and delete temp file after it's done 
        docco (-> fs.unlink 'Cakefile.coffee'), '-o doc/', 'Cakefile.coffee'
  


# ## Generate app sources documentation 

task 'doc:build:app', 'Build documentation files for the app sources', ->
  # Find all files in *app/* directory and give them to Docco
  walkDir ((files) ->
    if files.length == 0
      console.log('### No source files for app')
    else
      console.log('### Generate app documentation')
      docco null, '-o doc/app/', files.join(' ')

  ), 'app', '.coffee'
  

  
# ## Generate specs documentation

task 'doc:build:specs', 'Build documentation files for the spec sources', ->
  # Find all files in *spec/* directory and give them to Docco
  walkDir ((files) ->
    if files.length == 0
      console.log('### No source files for specs')  
    else
      console.log('### Generate specs documentation')
      docco null, '-o doc/spec/', files.join(' ')
      
  ), 'spec', '.coffee'
  

  
# ## Generate all documentation files

task 'doc:build', 'Build documentation files from source and spec files', ->
  invoke 'doc:build:cakefile'
  invoke 'doc:build:app'
  invoke 'doc:build:specs'
  
