files.forEach( function(file) {
  print('intserting into db:',file)
  var data = JSON.parse(cat('/db-setup/'+file))
  data._id = data.uuid
  db.devices.update({_id: data._id}, data, {upsert: true})
})
