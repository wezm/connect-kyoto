# Derived from https://github.com/assaf/zombie/blob/master/Cakefile, MIT licenced

fs            = require("fs")
path          = require("path")
{spawn, exec} = require("child_process")
stdout        = process.stdout

# Use executables installed with npm bundle.
process.env["PATH"] = "node_modules/.bin:#{process.env["PATH"]}"

# ANSI Terminal Colors.
bold  = "\033[0;1m"
red   = "\033[0;31m"
green = "\033[0;32m"
reset = "\033[0m"

# Log a message with a color.
log = (message, color, explanation) ->
  console.log color + message + reset + ' ' + (explanation or '')

# Handle error and kill the process.
onerror = (err)->
  if err
    process.stdout.write "#{red}#{err.stack}#{reset}\n"
    process.exit -1


## Building ##

build = (callback)->
  log "Compiling CoffeeScript to JavaScript ...", green
  exec "rm -rf lib && coffee -c -l -b -o lib src", (err, stdout)->
    callback err
task "build", "Compile CoffeeScript to JavaScript", -> build onerror

task "watch", "Continously compile CoffeeScript to JavaScript", ->
  cmd = spawn("coffee", ["-cw", "-o", ".", "src"])
  cmd.stdout.on "data", (data)-> process.stdout.write green + data + reset
  cmd.on "error", onerror


clean = (callback)->
  exec "rm -rf lib", callback
task "clean", "Remove temporary files and such", -> clean onerror


## Testing ##

runTests = (callback)->
  log "Running test suite ...", green
  exec "nodeunit test", (err, stdout)->
    process.stdout.write stdout
    callback err if callback
task "test", "Run all tests", ->
  runTests (err)->
    process.stdout.on "drain", -> process.exit -1 if err
