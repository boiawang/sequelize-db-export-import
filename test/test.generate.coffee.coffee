exec = require('child_process').exec
mocha = require('mocha')
assert = require('assert')

describe('it can create coffee file', () ->
  @timeout(50000)

  it '', (done) ->
    exec('node ./bin/www -d test', (error, stdout, stderr) ->
      console.log error, stdout, stderr
      done()
    )
)
