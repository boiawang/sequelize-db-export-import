mocha = require('mocha')
assert = require('assert')
config = require('../config')
ModelExport = require('../../lib/ModelExport')
ModelLink = require('../../lib/ModelLink')

describe('Class ModelExport', () ->
  modelExport = null

  mocha.before (done) ->
    modelExport = new ModelExport(config)
    done()

  it 'should be extend ModelExport', (done) ->
    assert.ok(modelExport instanceof ModelLink)
    done()
)
