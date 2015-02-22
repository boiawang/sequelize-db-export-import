mocha = require('mocha')
assert = require('assert')
config = require('../config')
fs = require('fs')
ModelExport = require('../../lib/ModelExport')
ModelLink = require('../../lib/ModelLink')
testUtils = require('../utils')
del = require('del')

describe('Class ModelExport', () ->
  @timeout(30000)
  modelExport = null

  mocha.before (done) ->
    config.dir = config.output
    config.outputFileType = config.compile
    modelExport = new ModelExport(config)
    testUtils.createTables(done)

  mocha.after (done) ->
    testUtils.dropAllTables(done)

  it 'should be extend ModelExport', (done) ->
    assert.ok(modelExport instanceof ModelLink)
    done()

  describe('#createOutputDir()', () ->
    it 'should create model directory', (done) ->
      modelExport.createOutputDir().then (isHave) ->
        assert.equal(isHave, true)
        done()

  )

  describe('#createModels()', () ->
    it 'should generate all models file', (done) ->
      modelExport.createModels().then (isCreated) ->
        assert.equal(isCreated, true)
        assert.deepEqual(fs.readdirSync(config.dir), ["role.#{config.compile}", "tag.#{config.compile}", "user.#{config.compile}"])
        del.sync(config.dir)
        done()

    it 'should generate js file', (done) ->
      config.outputFileType = 'js'
      modelExport = new ModelExport(config)
      modelExport.createModels().then (isCreated) ->
        assert.equal(isCreated, true)
        assert.deepEqual(fs.readdirSync(config.dir), ["role.js", "tag.js", "user.js"])
        del.sync(config.dir)
        done()
  )

)
