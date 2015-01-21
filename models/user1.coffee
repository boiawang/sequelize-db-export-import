module.exports = (sequelize, DataTypes) ->
  User1 = sequelize.define 'User1',
    id:
      type: DataTypes.INTEGER(11).UNSIGNED
      allowNull: false
      autoIncrement: true
      primaryKey: true
  ,
    tableName: 'user1'