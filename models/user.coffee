module.exports = (sequelize, DataTypes) ->
  User = sequelize.define 'User',
    id:
      type: DataTypes.INTEGER(11).UNSIGNED
      allowNull: false
      autoIncrement: true
      primaryKey: true
  ,
    tableName: 'user'