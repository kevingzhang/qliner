Meteor.publish 'storeInfo', (storeId)->
  console.log "publish storeInfo ", storeId
  return storeColl.find _id:storeId

