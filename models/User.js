const { mapUsers } = require('../utils');

module.exports = class Users {
  static _client ;
  static _tableName = 'users';

  static async createTableIfNotExists () {
    return this._client.query(`
      CREATE TABLE IF NOT EXISTS "users"(
        "id" serial PRIMARY KEY,
        "first_name" varchar(64) NOT NULL, 
        "last_name" varchar(64) NOT NULL,
        "email" varchar(256) NOT NULL CHECK("email" != ''),
        "is_male" boolean NOT NULL,
        "birthday" date NOT NULL CHECK (
          "birthday" < current_date 
          AND "birthday" > '1900-1-1'
        ),
        "height" numeric(3,2) NOT NULL CHECK(
          "height" BETWEEN 0.2 AND 2.5
        ),
        CONSTRAINT "CK_FULL_NAME" CHECK (
          "first_name" != ''
          AND "last_name" != ''
        )
      );
    `);
  }

  static async findAll () {
    return this._client.query(`SELECT * FROM ${this._tableName}`);
  }

  static async bulkCreate (users) {
    return this._client.query(`
      INSERT INTO "users" (
        "first_name",
        "last_name",
        "email",
        "is_male",
        "birthday",
        "height"
      ) VALUES ${mapUsers(users)};`);
  }
}