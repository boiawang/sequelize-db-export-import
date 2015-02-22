ModelLink = require('./ModelLink')
Q = require('q')
fs = require('fs')
path = require('path')
_ = require('lodash')
types = require('../config/datatypes').types

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
        generatePromises = []

        tables.forEach (table, index) ->
          generatePromises.push self.generateTemps({
            tableName: table
            modelName: table[0].toUpperCase() + table.substring(1)
            fields: results[1][table]
          })

        Q.all(generatePromises).then (results) ->
          deferred.resolve(true)
          console.log('all models are generated from db')
          # process.exit(0)

      deferred.promise

    # create file
    # @params Object data model
    generateTemps: (data = {}, callback) ->
      deferred = Q.defer()

      type = @opts.outputFileType
      
      if @opts.space is 2
        space = '  '
      else
        space = '    '

      if not /coffee|js/.test(type)
        return ''

      text = ''

      if type is 'coffee'
        text += "module.exports = (sequelize, DataTypes) ->\n&#{data.modelName} = sequelize.define \'#{data.modelName}\',\n"
      else if type is 'js'
        text += "module.exports = function(sequelize, DataTypes) {\n&return sequelize.define(\'#{data.modelName}\', {\n"
  
      # 生成模型 &代表空格，默认两个空格
      _.each data.fields, (field, key) ->

        if type is 'coffee'
          text += "&&#{key}:\n"
        else if type is 'js'
          text += "&&#{key}: {\n"

        _.each field, (value, attr) ->
          if not _.isNull(value)

            if attr is 'type'
              typeOutStr = ''
              _.each types, (type) ->
                if value.match(type.name)
                  typeOutStr = 'DataTypes.' + type.value

                  # 判断是否为int类型
                  if type.value is 'INTEGER'
                    length = value.match(/\(\d+\)/)
                    typeOutStr += if length then length else ''

                    if value.match('UNSIGNED')
                      typeOutStr += '.UNSIGNED'
              value = typeOutStr

            if type is 'coffee'
              text += "&&&#{attr}: #{value}\n"
            else if type is 'js'
              text += "&&&#{attr}: #{value},\n"

        if type is 'js'
          text += '&&},\n'

      if type is 'coffee'
        text += "&,\n&&tableName: \'#{data.tableName}\'"
      else if type is 'js'
        text += "&}, {\n&&tableName: \'#{data.tableName}\'\n&});\n};"

      fs.writeFile("#{@dir}/#{data.tableName}.#{type}", text.replace(/&/g, space), (err) ->
        if err
          console.log("create #{data.modelName} fail")
        else
          console.log("#{data.modelName} is created")
        deferred.resolve(true)
      )

      deferred.promise

  return ModelExport
)()
