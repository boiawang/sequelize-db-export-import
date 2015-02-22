mocha = require('mocha')
assert = require('assert')
config = require('../config')
# ModelImport = require('../../lib/ModelImport')
ModelLink = require('../../lib/ModelLink')
Link = require('../../lib')
exec = require('child_process').exec
testUtils = require('../utils')

describe('Class ModelImport', () ->
  modelImport = null
  modelExport = null
  modelLink = null

  mocha.before (done) ->
    config.dir = config.output
    config.outputFileType = config.compile
    modelExport = new Link.ModelExport(config)
    modelImport = new Link.ModelImport(config)
    testUtils.createTables(done)
  
  mocha.after (done) ->
    testUtils.dropAllTables(done)

  it 'should be extend ModelLink', (done) ->
    assert.ok(modelImport instanceof ModelLink)
    done()

  describe('#getModelFiles()', () ->

    mocha.after (done) ->
      testUtils.dropAllTables(done)

    it 'should get model files', (done) ->
      modelExport.createModels().then (isCreated) ->
        modelImport.getModelFiles().then (files) ->
          assert.deepEqual(files, [ 'role', 'tag', 'user' ])
        done()
  )

  describe('#createTable()', () ->
    it 'should createTable', (done) ->
      modelImport.generateTables().then () ->
        modelImport.showAllTables().then (tables) ->
          assert.deepEqual(tables, [ 'role', 'tag', 'user' ])
          done()
  )
)
