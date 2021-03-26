const { random } = require('lodash');
const _ = require('lodash');

module.exports.mapUsers = users => {
  return users.map(
    ({ name: { first, last }, email, gender, dob: { date } }) =>
      `('${first}','${last}','${email}','${gender === 'male'}','${date}','${(
        Math.random() + 1
      ).toFixed(2)}')`
  )
  .join(',');
}

const PHONES_BRANDS = [
  'Samsung',
  'Nokia',
  'Huawei',
  'Xiaomi',
  'IPhone',
  'Honor',
  'Siemens',
  'Motorola'
];

const TASK_NAMES = [
  'Do stuff',
  'Do stuff successfully',
  'Relax',
  'Relax at home',
  'Relax outside',
  'Exist',
  'Drink',
  'Eat',
  'Drink healthy',
  'Eat healthy',
  'Sleep'
];

const TASK_PRIORITY = [
  'DO IT NOW',
  'extreme',
  'high',
  'medium',
  'low',
  'trivial',
  'maybe in this century'
];

const generatePhone = key => ({
  brand: PHONES_BRANDS[_.random(0, PHONES_BRANDS.length - 1, false)],
  model: `${key} model ${_.random(0, 100, false)}`,
  price: _.random(1500, 40000, false),
  quantity: _.random(100, 2500, false)
});

module.exports.generatePhones = (length = 50) =>
  new Array(length).fill(null).map((_, i) => generatePhone(i));


const createTask = () => ({
  name: TASK_NAMES[_.random(0, TASK_NAMES.length - 1, false)],
  priority: TASK_PRIORITY[_.random(0, TASK_PRIORITY.length - 1, false)],
  description : `Pseudorandom descrption №${_.random(1,1000,false)}`,
  is_done: 0.5 > random()
})

module.exports.createTasks = (length = 10) => 
  new Array(length).fill(null).map(() => createTask())
