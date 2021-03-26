class Tasks {
  static _client;
  static _tableName = 'tasks';

  static async bulkCreate (values) {

    const tasksString = values
    .map(
      ({name, user,  priority, description, is_done}) => {
        return `('${name}','${user}','${priority}','${description}', '${is_done}')`
      }
    )
    .join(',');

    const {rows} = this._client.query(`
      INSERT INTO "${this._tableName}" (
        "name",
        "user",
        "priority",
        "description",
        "is_done"    
      ) VALUES ${tasksString}
    `)
    return rows;
  }
}

module.exports = Tasks;