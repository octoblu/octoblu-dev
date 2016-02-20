print('inserting database values')
var data = JSON.parse(cat('/js/setup-octoblu.json'))
for (var i in data) {
  data[i]._id = data[i].uuid
  db.devices.insert(data[i])
}
print('done')
