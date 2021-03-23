const {User, client} =require('./models');
const {loadUsers} =require('./api');

start();

async function start() {
  await client.connect();

  const users = await loadUsers();

  await User.createTableIfNotExists();
  const result = await User.bulkCreate(users);
  console.log(result);

  await client.end();
}
