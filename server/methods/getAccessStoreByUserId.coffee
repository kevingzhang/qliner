Meteor.methods
  getAccessStoreByUserId : ()->
    userId = Meteor.userId()
    console.log userId
    if userId?
      #stores = storeColl.find {$or:['access.admin':{$elemMatch:userId}, 'access.keeper':{$elemMatch:userId}, 'access.waiter':{$elemMatch:userId}, 'access.staff':{$elemMatch: userId}]}
      stores = storeColl.find {$or:[{'access.admin':userId}, {'access.keeper':userId}, {'access.waiter':userId}, {'access.staff':userId}]}
      

      console.log "store Number:", stores.count()
      ret = []
      stores.forEach (s)->
        storeObj = {_id:s._id, storeName:s.name, storeAddress:s.property?.address}
        if s.access.staff.indexOf(userId) isnt -1
          storeObj.role = 'staff'
        if s.access.waiter.indexOf(userId) isnt -1
          storeObj.role = 'waiter'
        if s.access.keeper.indexOf(userId) isnt -1
          storeObj.role = 'keeper'
        if s.access.admin.indexOf(userId) isnt -1
          storeObj.role = 'admin'
        ret.push storeObj 
      return ret 
    else
      return null
