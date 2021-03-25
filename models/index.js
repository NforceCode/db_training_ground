const {Client} = require("pg");
const config = require("../configs/db.json");
const User = require('./User');
const Phone = require('./Phone');
const Tasks = require('./Tasks');

const client = new Client(config);

User._client = client;
Phone._client = client;
Tasks._client = client;

module.exports = {
  client,
  User,
  Phone,
  Tasks
}