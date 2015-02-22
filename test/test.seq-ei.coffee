exec = require('child_process').exec
mocha = require('mocha')
assert = require('assert')
Q = require('q')
fs = require('fs')
_ = require('lodash')
DataTypes = require('../node_modules/sequelize/lib/data-types')
config = require('./config')
Sequelize = require('sequelize')
testUtils = require('./utils')
ModelLink = require('../lib/modelLink')
del = require('del')

sequelize = null
modelLink = null

executeCmd = (type, callback) ->
  deferred = Q.defer()

  if typeof type is 'function'
    callback = type

  cmd = "node ./bin/#{config.name} -d #{config.database} -o ./test/models"

  if type is 'import'
    cmd += ' -r'

  exec(cmd, (err, stdout, stderr) ->
    callback and callback()
    deferred.resolve(true)
  )

  deferred.promise

describe('seq-ei', () ->
  @timeout(30000)

  describe 'export', () ->
    mocha.before (done) ->
      modelLink = new ModelLink(config)
      testUtils.createTables(done).then () ->
        executeCmd(done)

    mocha.after (done) ->
      del.sync(config.output)
      testUtils.dropAllTables(done)

    it 'should create models', (done) ->
      fs.readdir('./test/models', (err, files) ->
        assert.equal(err, null)
        # assert.notEqual(files.indexOf('tag.coffee'), -1)
        # assert.notEqual(files.indexOf('user.coffee'), -1)
        # assert.notEqual(files.indexOf('role.coffee'), -1)
        done()
      )

  # describe('import', () ->
  #   mocha.before (done) ->
  #     modelLink = new ModelLink(config)
  #     testUtils.createTables(done).then () ->
  #       executeCmd().then () ->
  #         testUtils.dropAllTables(done)

  #   mocha.after (done) ->
  #     del.sync(config.output)
  #     testUtils.dropAllTables(done)

  #   it 'should create 3 tables', (done) ->
  #     executeCmd('import').then () ->
  #       modelLink.describeAllTables().then (tables) ->
  #         console.log tables, 3333
  #         tables = _.pluck(tables, "Tables_in_#{config.database}")

  #         assert.notEqual(tables.indexOf('tag'), -1)
  #         assert.notEqual(tables.indexOf('user'), -1)
  #         assert.notEqual(tables.indexOf('role'), -1)
  #         done()
  # )
)

