Meteor.methods
  addUserAccessToStore: (userId, storeId, right)->
    if Meteor.user().emails[0] isnt 'asdf@asdf.com'
      throw new Meteor.Error 'Only Admin can access addUserAccessToStore function'
    switch right
      when 'access'
        storeColl.update _id:storeId, $push:{access: userId}
      when 'waiter'
        storeColl.update _id:storeId, $push:{access: userId, waiter: userId}
      when 'admin'
        storeColl.update _id:storeId, $push:{access: userId, waiter:userId, admin:userId}
      else
        throw new Meteor.Error "addUserAccessToStore: New right not handled: #{right}"

  removeUserAccessToStore : (userId, storeId, right)->
    if Meteor.user().emails[0] isnt 'asdf@asdf.com'
      throw new Meteor.Error 'Only Admin can access removeUserAccessToStore function'
    switch right
      when 'access'
        storeColl.update _id:storeId, $pull:{access: userId}
      when 'waiter'
        storeColl.update _id:storeId, $pull:{access: userId, waiter: userId}
      when 'admin'
        storeColl.update _id:storeId, $pull:{access: userId, waiter:userId, admin:userId}
      else
        throw new Meteor.Error "removeUserAccessToStore: New right not handled: #{right}"
