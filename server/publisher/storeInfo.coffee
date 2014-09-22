Meteor.publish 'storeInfo', (storeId)->
  return storeColl.find _id:storeId

