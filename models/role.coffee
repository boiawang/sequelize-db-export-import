module.exports = (sequelize, DataTypes) ->
  Role = sequelize.define 'Role',
    id:
      type: DataTypes.INTEGER(11).UNSIGNED
      allowNull: false
      autoIncrement: true
      primaryKey: true
    name:
      type: DataTypes.STRING
      allowNull: false
    create_time:
      type: DataTypes.DATE
      allowNull: false
    update_time:
      type: DataTypes.DATE
      allowNull: false
  ,
    tableName: 'role'