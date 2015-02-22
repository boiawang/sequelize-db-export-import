Q = require('q')
link = require('../')
DataTypes = require('../node_modules/sequelize/lib/data-types')
config = require('./config')
Sequelize = require('sequelize')

sequelize = null
User = null
Tag  = null
Role = null

init = () ->
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

init()

module.exports = {
  createTables: (callback) ->
    deferred = Q.defer()

    Q.all([User.sync(), Tag.sync(), Role.sync()])
    .then (results) ->
      console.log 'create test tables success'
      deferred.resolve(true)
      callback and callback()

    deferred.promise

  dropAllTables: (callback) ->
    sequelize.dropAllSchemas().then () ->
      callback and callback()
    
}
