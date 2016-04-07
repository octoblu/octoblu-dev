files.forEach( function(file) {
  print('inserting into db:',file)
  var data = JSON.parse(cat('/db-setup/'+file))
  var database = file.split('/')[1]
  var collection = file.split('/')[2]
  data._id = data.uuid
  db = db.getSiblingDB(database)
  db.createCollection(collection)
  db[collection].update({_id: data._id}, data, {upsert: true})
})
