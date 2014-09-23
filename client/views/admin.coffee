Template.admin.events
  'click #addStoreBtn': (e,t) ->
    storeName = (t.find '#addStoreInput').value
    return unless !!storeName
    address = (t.find '#addStoreAddress').value
    return unless !!address
    Meteor.call 'addNewStore', storeName, {storeName:storeName, storeAddress:address}, (e,r)->
      if e?
        console.log "ERROR: addNewStore:", e.message
      else
        #r is expectd to be the id of store
        bootbox.alert "Store #{r} is added. Store name is #{storeName}"

    # ...