print('inserting database values')
var data = JSON.parse(cat('/js/setup-octoblu.json'))
for (var i in data) {
  db.devices.insert(data[i])
}
print('done')
