const path = require('path');
const fs = require('fs').promises;
const _ = require('lodash');
const {User, client, Phone, Tasks} =require('./models');
const {loadUsers} =require('./api');
const {generatePhones, createTasks} = require('./utils');

start();

async function start() {
  await client.connect();

  const resetDbQueryString = await fs.readFile(
    path.join(__dirname, '/sql/reset-db-query.sql'),
    'utf8'
  );
  await client.query(resetDbQueryString);
  
  const users = await User.bulkCreate(await loadUsers());
  const phones = await Phone.bulkCreate(generatePhones()); 
  // добавлять существующих юзерей в объект больновато
  await Tasks.bulkCreate(createTasks(1500)
  .map(task =>  {
    return {...task, user : _.random(1, users.length -1, false)}
  }));

  /* СОЗДАЕМ ЗАКАЗ */
  const ordersValuesString = users
    .map(u => new Array(_.random(1, 5, false)).fill(null).map(() => `(${u.user})`).join(','))
    .join(',');

  const { rows: order } = await client.query(`
    INSERT INTO "order" ("user")
    VALUES ${ordersValuesString}
    RETURNING "order";
  `);

  /* НАПОЛНЯЕМ ЗАКАЗ ТЕЛЕФОНАМИ */
  const phonesToOrdersValuesString = order
    .map(o => {
      const arr = new Array(_.random(1, phones.length)).fill(null).map(
        () => phones[_.random(1, phones.length - 1)]
      );

      return [...new Set(arr)]
        .map(p => `(${o.order}, ${p.phone}, ${_.random(1, 4)})`)
        .join(',');
    })
    .join(',');

  await client.query(`
  INSERT INTO phone_to_order ("order", "phone", "quantity")
  VALUES ${phonesToOrdersValuesString};
`);

  await client.end();
}
