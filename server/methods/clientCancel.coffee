Meteor.methods
  'cancelMe':(qId, storeId, phoneNumber, email)->
    console.log "cancelMe #{qId}, #{storeId}, #{phoneNumber}, #{email}"
    queueObj = queueColl.findOne qId
    unless queueObj then throw new Meteor.Error ('Cannot find in queue')
    

    if (queueObj.storeId is storeId) and ((queueObj.usePhoneNumber is phoneNumber ) or (queueObj.userEmail is email))
      notifyObj = {}
      
      notifyObj.name = 'User Cancelled'
      notifyObj.autoCleanup = 30

      queueColl.update {_id:qId}, {$set:{status:'userCancelled'}, $push:{notifications:notifyObj}}
      if notifyObj.autoCleanup >0
        Meteor.setTimeout ()->
          console.log "timeout to remove notify #{qId}, #{notifyObj.name}"
          queueColl.update {_id:qId}, {$pull:{notifications:{name:notifyObj.name}}}
        , notifyObj.autoCleanup * 1000
        return 'done'
    else
      throw new Meteor.Error ('Cannot ID this user is working on his own queue')
