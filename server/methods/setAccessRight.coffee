Meteor.methods

  addUserAccessToStore: (userId, storeId, right)->
    if Meteor.user()?.emails[0]?.address isnt 'asdf@asdf.com'
      throw new Meteor.Error 'Only Admin can access addUserAccessToStore function'
    switch right
      when 'staff'
        storeColl.update _id:storeId,{ $addToSet:{'access.staff': userId}}
      when 'waiter'
        storeColl.update _id:storeId, {$addToSet:{'access.waiter':userId, 'access.staff':userId}}
      when 'keeper'
        storeColl.update _id:storeId, {$addToSet:{'access.keeper':userId, 'access.waiter':userId, 'access.staff': userId}}
      when 'admin'
        storeColl.update _id:storeId, {$addToSet:{'access.admin': userId, 'access.keeper':userId, 'access.waiter':userId, 'access.staff': userId}}
      else
        throw new Meteor.Error "addUserAccessToStore: New right not handled: #{right}"

  removeUserAccessToStore : (userId, storeId, right)->
    if Meteor.user()?.emails[0]?.address isnt 'asdf@asdf.com'
      throw new Meteor.Error 'Only Admin can access removeUserAccessToStore function'
    switch right
      when 'staff'
        storeColl.update _id:storeId, {$pull:{'access.staff': userId}}
      when 'waiter'
        storeColl.update _id:storeId, {$pull:{'access.waiter':userId, 'access.staff': userId}}
      when 'keeper'
        storeColl.update _id:storeId, {$pull:{'access.keeper':userId, 'access.waiter':userId, 'access.staff': userId}}
      when 'admin'
        storeColl.update _id:storeId, {$pull:{'access.admin': userId, 'access.keeper':userId, 'access.waiter':userId, 'access.staff': userId}}
      else
        throw new Meteor.Error "removeUserAccessToStore: New right not handled: #{right}"

  addUserAccessToStoreByEmail: (email, storeId, right)->
    console.log "addUserAccessToStoreByEmail: (#{email}, #{storeId}, #{right})"
    users = Meteor.users.find {emails:{$elemMatch:{address: email}}}
    if users.count() > 1
      throw new Meteor.Error "More than one user has same email address #{email}. User merge is needed. Not done yet"
    if users.count() is 1
      user = users.fetch()[0]
      return Meteor.call 'addUserAccessToStore', user._id, storeId, right
    else
      throw new Meteor.Error "Cannot find user by email #{email}"

  removeUserAccessToStoreByEmail: (email, storeId, right)->
    users = Meteor.users.find {emails:{$elemMatch:{address: email}}}
    if users.count() > 1
      throw new Meteor.Error "More than one user has same email address #{email}. User merge is needed. Not done yet"
    if users.count() is 1
      user = users.fetch()[0]
      return Meteor.call 'removeUserAccessToStore', user._id, storeId, right
    else
      throw new Meteor.Error "Cannot find user by email #{email}"

  getHighestAccessRightToStore:(userId, storeId)->
    storeObj = storeColl.findOne _id:storeId
    unless storeObj?.access? then return ''
    if storeObj.access.admin?.indexOf(userId) > -1 then return 'admin'
    if storeObj.access.keeper?.indexOf(userId) > -1 then return 'keeper'
    if storeObj.access.waiter?.indexOf(userId) > -1 then return 'waiter'
    if storeObj.access.staff?.indexOf(userId) > -1 then return 'staff'
    return ''


