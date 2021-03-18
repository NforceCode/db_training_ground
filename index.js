const {Client} =require('pg');

const test_ground_config = {
  user: 'postgres',
  password: 'postgres',
  host: 'localhost',
  port: 5432,
  database: 'test_ground'
}

const test_ground = new Client(test_ground_config);


async function assumingDirectControl (query) {

  await test_ground.connect();

  await test_ground.query(`
    ${query}
  `);

  

  await test_ground.end();
}

// assumingDirectControl(`CREATE TABLE "Shepard"(
//   direct_control_assumed serial PRIMARY KEY
// );`);

assumingDirectControl(`
ALTER TABLE "Shepard" ADD COLUMN "indoctrination status" ;`
);