{ exec } = require 'child_process'

task 'build', 'Build project from src/*.coffee to lib/*.js', ->
  exec 'coffee --compile --output lib/ src/', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr

task 'build_test', 'Build project from spec/src/*.coffee to spec/lib/*.js', ->
  exec 'coffee --compile --output spec/lib/ spec/src/', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr
