mocha = require('mocha')
assert = require('assert')
config = require('../config')
ModelLink = require('../../lib/ModelLink')

describe('Class ModelLink', () ->
  modelLink = null

  mocha.before (done) ->
    modelLink = new ModelLink(config)
    done()

  it 'should be instanced', (done) ->
    assert.notEqual(modelLink.sequelize, null)
    assert.notEqual(modelLink.queryInterface, null)
    done()

  describe('#showAllTables', () ->
    it 'should show all tables', (done) ->
      modelLink.showAllTables().then (tables) ->
        assert.deepEqual(tables, ['role', 'tag', 'user'])
        done()
  )

  describe('describeTable', () ->
    it 'should describe all tables', (done) ->
      modelLink.describeAllTables().then (models) ->
        assert.ok(models.role)
        assert.ok(models.tag)
        assert.ok(models.user)
        done()
  )
)
