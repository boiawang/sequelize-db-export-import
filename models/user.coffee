module.exports = (sequelize, DataTypes) ->
  User = sequelize.define 'User',
    id:
      type: DataTypes.INTEGER(11).UNSIGNED
      allowNull: false
      autoIncrement: true
      primaryKey: true
    name:
      type: DataTypes.STRING
      allowNull: true
    admin:
      type: DataTypes.BOOLEAN
      allowNull: false
    age:
      type: DataTypes.INTEGER(6)
      allowNull: true
    create_time:
      type: DataTypes.DATE
      allowNull: false
    num:
      type: DataTypes.BIGINT
      allowNull: true
  ,
    tableName: 'user'