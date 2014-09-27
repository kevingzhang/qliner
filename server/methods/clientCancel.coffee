Meteor.methods
  'cancelMe':(qId, storeId, phoneNumber, email)->
    console.log "cancelMe #{qId}, #{storeId}, #{phoneNumber}, #{email}"
    queueObj = queueColl.findOne qId
    unless queueObj then throw new Meteor.Error ('Cannot find in queue')
    if (queueObj.storeId is storeId) and ((queueObj.usePhoneNumber is phoneNumber ) or (queueObj.userEmail is email))
      queueColl.update {_id:qId}, {$set:{status:'userCancelled'}}
    else
      throw new Meteor.Error ('Cannot ID this user is working on his own queue')
