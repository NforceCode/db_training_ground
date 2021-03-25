const _ = require('lodash');
const {get: users:results} 

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
  'Relax outside'
]

const generatePhone = key => ({
  brand: PHONES_BRANDS[_.random(0, PHONES_BRANDS.length - 1, false)],
  model: `${key} model ${_.random(0, 100, false)}`,
  price: _.random(1500, 40000, false),
  quantity: _.random(100, 2500, false)
});

module.exports.generatePhones = (length = 50) =>
  new Array(length).fill(null).map((_, i) => generatePhone(i));


const createTask = () => ({
  name: TASK_NAMES[_.random(0, TASK_NAMES.length - 1), false],
  user: _.random(0, )
})

module.exports.createTasks = async ()