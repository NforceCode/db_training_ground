class Tasks {
  static _client;
  static _tableName = 'Tasks';

  static async bulkCreate (tasks) {

    const tasksString = values
    .map(
      (name, user,  priority, description) => {
        `(${name}),(${user}),(${priority}), (${description})`
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