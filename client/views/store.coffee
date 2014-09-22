Template.store.events
  'click #addMeButton': (e,t) ->
    phoneNumber = (t.find '#addMePhoneNumber').value
    return unless !!phoneNumber 
    partyOfNumber = (t.find '#addMePartyOf').value
    return unless !!partyOfNumber
    storeId = t.data.storeInfo._id
    Meteor.call 'addMeInByPhoneNumber', storeId, phoneNumber, partyOfNumber, (e,r)->
      if e?
        console.log 'ERROR: Meteor.call addMeInByPhoneNumber :' , e.message
        return 
      bootbox.alert 'You are added!'
    # ...