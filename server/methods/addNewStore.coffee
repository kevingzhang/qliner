Meteor.methods
  'addNewStore' : (storeName, property)->
    newDoc = counterColl.findAndModify 
      query:{_id:'store'}
      update:{$inc:{curId:1}}
      new: true
      upsert: true
    unless newDoc?
      console.log "counterColl.findAndModify returns nothing"
      throw new Meteor.Error "counterColl.findAndModify returns nothing"
      
    newStoreId =  newDoc.curId
    return storeColl.insert 
      _id:"#{newStoreId}"
      name:storeName
      property:property
