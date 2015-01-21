ModelLink = require('./ModelLink')
Q = require('q')
fs = require('fs')
path = require('path')
_ = require('lodash')

templates = {
  coffee:
    text: 'module.exports = (sequelize, DataTypes) ->\n"<%= modelName %> = sequelize.define \'<%= modelName %>\',\n""<% _.forEach(fields, function(field, key) { %><%- key %>:\n<% _.forEach(field, function(value, key) { %><% if(!_.isNull(value)) { %>"""<%- key %>: <%- value %>\n<% } %><% }) %><% }) %>",\n""tableName: \'<%= tableName %>\''
}

module.exports = (() ->

  # models generate from db
  class ModelExport extends ModelLink
    constructor: (options) ->
      super options

      @dir = options.dir

    # create models dir
    createOutputDir: () ->
      deferred = Q.defer()

      fs.stat @dir, (err, stats) =>
        if err or not stats.isDirectory()
          fs.mkdir @dir, (err) ->
            if not err
              deferred.resolve(true)
        else
          deferred.resolve(true)

      deferred.promise

    # create all model files
    createModels: () ->
      deferred = Q.defer()
      self = @

      createOutputDirPromise = @createOutputDir()
      describeAllTablesPromise = @describeAllTables()

      Q.all([createOutputDirPromise, describeAllTablesPromise])
      .then (results) ->
        tables = Object.keys(results[1])

        tables.forEach (table) ->
          self.generateTemps({
            tableName: table
            modelName: table[0].toUpperCase() + table.substring(1)
            fields: results[1][table]
          }, self.opts.outputFileType)

      deferred.promise

    # create file
    # @todo create js file
    # @params Object data model
    # @params String type file type
    generateTemps: (data = {}, type = 'coffee') ->
      if not /coffee|js/.test(type)
        return ''

      text = ''

      text += "module.exports = (sequelize, DataTypes) ->\n&#{data.modelName} = sequelize.define \'#{data.modelName}\',\n&&"

      # 生成模型 &代表空格，默认两个
      _.each data.fields, (field, key) ->
        text += "#{key}:\n"

        _.each field, (value, attr) ->
          if not _.isNull(value)

            if attr is 'type'
              value = ('DataTypes.' + value).replace(/INT/, 'INTEGER').replace(/\s/, '.')

            text += "&&&#{attr}: #{value}\n"

      text += "&,\n&&tableName: \'#{data.tableName}\'"

      fs.writeFile("#{@dir}/#{data.tableName}.#{type}", text.replace(/&/g, '  '))

  return ModelExport
)()
