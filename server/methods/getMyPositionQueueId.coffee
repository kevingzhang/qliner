Meteor.methods
  'getMyPositionQueueId' : (storeId, phoneNumber, email)->
    console.log "#{storeId}, #{phoneNumber}, #{email}"
    queueObj = queueColl.findOne {storeId: storeId, status:{$exists:true}, $or:[{usePhoneNumber: phoneNumber},{useEmail:email}]}
    return queueObj?._id