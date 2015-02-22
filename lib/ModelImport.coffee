ModelLink = require('./ModelLink')
Q = require('q')
fs = require('fs')
_ = require('lodash')
path = require('path')
DataTypes = require('../node_modules/sequelize/lib/data-types')

module.exports = (() ->
  class ModelImport extends ModelLink
    # get all model files
    getModelFiles: () ->
      deferred = Q.defer()

      fs.readdir(@opts.dir, (err, files) ->
        files = _.map(files, (file) ->
          reg = /.js|.coffee/
          if file.match(reg)
            file = file.replace(reg, '')
            return file
        )
        deferred.resolve(files)
      )

      deferred.promise

    # create one table
    createTable: (model) ->
      deferred = Q.defer()

      model.sync().then (table) ->
        console.log "create #{table.getTableName()} success"
        deferred.resolve table
      , (err) ->
        console.log err

      deferred.promise

    generateTables: () ->
      deferred = Q.defer()
      self = @

      @getModelFiles().then (files) ->
        promises = []
        self.showAllTables().then (tables) ->
          _.each files, (file) ->

            # 判断是否存在该表，如果存在，不创建
            if not ~(_.indexOf(tables, file))
              promises.push(self.createTable(require(self.opts.dir + '/' + file)(self.sequelize, DataTypes)))

          Q.all(promises).then (results) ->
            console.log('all tables are created')
            deferred.resolve(true)
            # process.exit(0)

      deferred.promise
)()
