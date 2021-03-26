class Tasks {
  static _client;
  static _tableName = 'tasks';

  static async bulkCreate (values) {

    const tasksString = values
    .map(
      ({name, user,  priority, description}) => {
        return `('${name}','${user}','${priority}','${description}')`
      }
    )
    .join(',');

    const {rows} = this._client.query(`
      INSERT INTO "${this._tableName}" (
        "name",
        "user",
        "priority",
        "description"        
      ) VALUES ${tasksString}
    `)
    return rows;
  }
}

module.exports = Tasks;