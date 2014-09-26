Template.store.events
  'click #addMeButton': (e,t) ->
    phoneNumber = (t.find '#addMePhoneNumber').value
    email = (t.find '#addMeEmail').value
    
    partyOfNumber = (t.find '#addMePartyOf').value
    return unless !!partyOfNumber
    storeId = t.data.storeInfo._id


    if !!phoneNumber
      unless App.Util.validatePhoneNumber(phoneNumber)
        bootbox.alert "Phone number is not valid, try again please"
        return 
      phoneNumber = phoneNumber.replace(/(\d{3})(\d{3})(\d{4})/, '$1-$2-$3')
      
      
      Meteor.call 'addMeInByPhoneNumber', storeId, phoneNumber, email, partyOfNumber, (e,r)->
        if e?
          console.log 'ERROR: Meteor.call addMeInByPhoneNumber :' , e.message
          return 
        App.Util.setCookie 'phoneNumber', phoneNumber
        if !!email
          App.Util.setCookie 'email', email
        Session.set 'myPositionQueueId', r.queueId
        bootbox.alert "You are added! Your name will display as #{r.displayFakeName}"

      # ...
    else if !!email
      Meteor.call 'addMeInByEmail', storeId, email, partyOfNumber, (e,r)->
        if e?
          console.log 'ERROR: Meteor.call addMeInByEmail :' , e.message
          return 
        App.Util.setCookie 'email', email
        Session.set 'myPositionQueueId', r.queueId
        bootbox.alert "You are added! Your name will display as #{r.displayFakeName}"
    else
      bootbox.alert "Please input either phone number or email"


Template.store.helpers
  waitTime:()->
    nowTime = Session.get('nowTime')
    
    moment.duration(nowTime - @inTime).humanize()

  localSavedPhoneNumber:()->
    App.Util.getCookie('phoneNumber')

  localSavedEmail:()->
    App.Util.getCookie('email')

  isMyPosition:(qId, storeId)->
    console.log "isMyPosition, #{qId}, #{storeId}"
    myQid = Session.get 'myPositionQueueId'

    unless myQid?
      Meteor.call 'getMyPositionQueueId', storeId, App.Util.getCookie('phoneNumber'), App.Util.getCookie('email'), (e,r)->
        if e?
          console.log 'getMyPositionQueueId ERROR:', e.message
        else
          Session.set 'myPositionQueueId', r

    if qId is myQid
      return 'my-position'
    else
      return ''