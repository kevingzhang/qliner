Template.storeKeeperSelector.helpers
  accessableStores:()->
    ret = Session.get 'storeKeeperSelector/accessableStores'
    if ret?
      return ret 
    else
      Meteor.call 'getAccessStoreByUserId', (e,r)->
        if e? then throw new Meteor.Error 'getAccessStoreByUserId ERROR:', e.message
        if r?
          Session.set 'storeKeeperSelector/accessableStores', r
        else
          bootbox.alert 'Are you sure you logged in and have access to any store?'

