mocha = require('mocha')
assert = require('assert')
config = require('../config')
ModelLink = require('../../lib/ModelLink')
testUtils = require('../utils')

describe('Class ModelLink', () ->
  modelLink = null

  mocha.before (done) ->
    modelLink = new ModelLink(config)
    testUtils.createTables(done)

  mocha.after (done) ->
    testUtils.dropAllTables(done)

  it 'should be instanced', (done) ->
    assert.notEqual(modelLink.sequelize, null)
    assert.notEqual(modelLink.queryInterface, null)
    done()

  describe('#describeOneTable', () ->
    it 'should describe one table', (done) ->
      modelLink.describeOneTable('user').then (table) ->
        assert.notEqual(table.user, null)
        done()
  )

  describe('describeTable', () ->
    it 'should show all tables', (done) ->
      modelLink.showAllTables().then (tables) ->
        assert.deepEqual(tables, ['role', 'tag', 'user'])
        done()
    it 'should describe all tables', (done) ->
      modelLink.describeAllTables().then (models) ->
        assert.ok(models.role)
        assert.ok(models.tag)
        assert.ok(models.user)
        done()
  )
)
