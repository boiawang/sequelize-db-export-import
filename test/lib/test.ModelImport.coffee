mocha = require('mocha')
assert = require('assert')
config = require('../config')
ModelImport = require('../../lib/ModelImport')
ModelLink = require('../../lib/ModelLink')
exec = require('child_process').exec

describe('Class ModelImport', () ->
  modelImport = null

  mocha.before (done) ->
    modelImport = new ModelImport(config)
    done()

  it 'should be extend ModelLink', (done) ->
    assert.ok(modelImport instanceof ModelLink)
    done()

)
