module.exports.mapUsers = users => {
  return users.map(
    ({ name: { first, last }, email, gender, dob: { date } }) =>
      `('${first}','${last}','${email}','${gender === 'male'}','${date}','${(
        Math.random() + 1
      ).toFixed(2)}')`
  )
  .join(',');
}