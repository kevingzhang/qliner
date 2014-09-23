Meteor.publish 'storeQueue', (storeId)->
  return queueColl.find 
    storeId:storeId
    status:{$exists:true}