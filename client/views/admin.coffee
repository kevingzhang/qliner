Template.admin.events
  'click #addStoreBtn': (e,t) ->
    value = (t.find '#addStoreInput').value
    return unless !!value
    Meteor.call 'addNewStore', value, (e,r)->
      if e?
        console.log "ERROR: addNewStore:", e.message
      else
        #r is expectd to be the id of store
        bootbox.alert "Store #{r} is added. Store name is #{value}"

    # ...