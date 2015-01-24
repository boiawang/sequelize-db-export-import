exec = require('child_process').exec
mocha = require('mocha')
assert = require('assert')
Q = require('q')
fs = require('fs')
_ = require('lodash')
DataTypes = require('../node_modules/sequelize/lib/data-types')
config = require('./config')
Sequelize = require('sequelize')

sequelize = null

init = (type, callback) ->
  sequelize = new Sequelize(config.database, config.user, config.password, config)

  User = sequelize.User = sequelize.define 'User',
    id:
      type: DataTypes.INTEGER(11)
      allowNull: false
      autoIncrement: true
      primaryKey: true
    name:
      type: DataTypes.STRING
      defaultValue: ''
  ,
    tableName: 'user'

  Tag = sequelize.Tag = sequelize.define 'Tag',
    id:
      type: DataTypes.INTEGER(11).UNSIGNED
      allowNull: false
      autoIncrement: true
      primaryKey: true
    name:
      type: DataTypes.STRING
      defaultValue: ''
  ,
    tableName: 'tag'

  Role = sequelize.Role = sequelize.define 'Role',
    id:
      type: DataTypes.INTEGER(11).UNSIGNED
      allowNull: false
      autoIncrement: true
      primaryKey: true
    name:
      type: DataTypes.STRING
      defaultValue: ''
  ,
    tableName: 'role'

  Q.all([User.sync(), Tag.sync(), Role.sync()])
  .then (results) ->
    console.log 'create test tables success'

    executeCmd(type, callback)

executeCmd = (type, callback) ->

  if typeof type is 'function'
    callback = type

  cmd = "node ./bin/#{config.name} -d #{config.database} -o ./test/models"

  if type is 'import'
    cmd += ' -r'

  exec(cmd, (err, stdout, stderr) ->
    callback and callback()
  )

dropAllTables = (callback) ->
  sequelize.dropAllSchemas().then () ->
    callback and callback()

describe('seq-ei', () ->
  @timeout(30000)

  describe 'export', () ->

    mocha.before (done) ->
      init(done)

    mocha.after (done) ->
      dropAllTables(done)

    it 'should create models', (done) ->
      fs.readdir('./test/models', (err, files) ->
        assert.equal(err, null)
        assert.notEqual(files.indexOf('tag.coffee'), -1)
        assert.notEqual(files.indexOf('user.coffee'), -1)
        assert.notEqual(files.indexOf('role.coffee'), -1)
        done()
      )

  describe('import', () ->

    mocha.before (done) ->
      init('import', done)

    mocha.after (done) ->
      dropAllTables(done)

    it 'should create 3 tables', (done) ->
      sequelize.showAllSchemas().then (tables) ->
        tables = _.pluck(tables, "Tables_in_#{config.database}")

        assert.notEqual(tables.indexOf('tag'), -1)
        assert.notEqual(tables.indexOf('user'), -1)
        assert.notEqual(tables.indexOf('role'), -1)
        done()
  
  )
)

