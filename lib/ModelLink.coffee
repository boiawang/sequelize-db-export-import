Sequelize = require('sequelize')
Q = require('q')
_ = require('lodash')

module.exports = (() ->
  class ModelLink
    constructor: (options) ->
      @opts = options
      @sequelize = sequelize = new Sequelize(options.database, options.user, options.password, options)
      @queryInterface = sequelize.getQueryInterface().QueryGenerator
      @models = {}

    # show all tables
    showAllTables: () ->
      @sequelize.showAllSchemas().then (tables) =>
        if @opts.dialect == 'sqlite'
          _tables = tables
        else
          _tables = _.map(tables, "Tables_in_#{@opts.database}")
        return _tables

    # describe one table
    describeOneTable: (table) ->
      oneTable = {}
      @sequelize.query(@queryInterface.describeTableQuery(table), {
        # raw: true
        # plain: true
      }).then (fields) =>
        # if fields.id
        #   fields.id.autoIncrement = true
        #   fields.id.primaryKey = true

        if @opts.dialect == 'sqlite'
          columnInfoList = []
          columnInfo = {}
          for key, field of fields
            if field.defaultValue == undefined or field.defaultValue == null
              defaultValue = null
            else
              if field.type == 'TINYINT(1)' then defaultValue = field.defaultValue else defaultValue = "'" + field.defaultValue + "'"
            columnInfo = {
              Field: key,
              Type: field.type.toLowerCase(),
              Null: if field.allowNull then 'YES' else 'NO',
              Default: defaultValue,
              Key: if field.primaryKey == true then 'PRI' else null
            }
            columnInfoList.push(columnInfo)

          oneTable[table] = columnInfoList
          @models[table] = columnInfoList
        else
          oneTable[table] = fields[0]
          @models[table] = fields[0]

        return oneTable

    # describe all tables
    describeAllTables: () ->
      deferred = Q.defer()
      self = @

      @showAllTables().then (tables) ->
        promises = []

        tables.forEach (table) ->
          promises.push(self.describeOneTable(table))

        Q.all(promises).then (allTables) ->
          deferred.resolve(self.models)

      deferred.promise

)()
