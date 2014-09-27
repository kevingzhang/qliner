Template.store.rendered = (e,t)->
  unless (Session.get 'myPositionQueueId')?
    Meteor.call 'getMyPositionQueueId', @data.storeInfo._id, App.Util.getCookie('phoneNumber'), App.Util.getCookie('email'), (e,r)->
      if e?
        console.log 'getMyPositionQueueId ERROR:', e.message
      else
        Session.set 'myPositionQueueId', r


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
        Session.set 'myPositionQueueId', r.qId
        bootbox.alert "You are added! Your name will display as #{r.displayFakeName}"

      # ...
    else if !!email
      Meteor.call 'addMeInByEmail', storeId, email, partyOfNumber, (e,r)->
        if e?
          console.log 'ERROR: Meteor.call addMeInByEmail :' , e.message
          return 
        App.Util.setCookie 'email', email
        Session.set 'myPositionQueueId', r.qId
        bootbox.alert "You are added! Your name will display as #{r.displayFakeName}"
    else
      bootbox.alert "Please input either phone number or email"


  'click #cancelMeButton':(e,t)->
    myQid = Session.get 'myPositionQueueId'
    unless myQid?
      console.log "ERROR:You are not in the queue"
    Meteor.call 'cancelMe', myQid, t.data.storeInfo._id, App.Util.getCookie('phoneNumber'), App.Util.getCookie('email'), (e,r)->
      if e?
        console.log "ERROR:", e.message
      else
        Session.set 'myPositionQueueId', undefined


Template.store.helpers
  waitTime:()->
    nowTime = Session.get('nowTime')
    
    moment.duration(nowTime - @inTime).humanize()

  localSavedPhoneNumber:()->
    App.Util.getCookie('phoneNumber')

  localSavedEmail:()->
    App.Util.getCookie('email')

  inQueueStatus:(status)->
    myQid = Session.get 'myPositionQueueId'
    unless myQid? then return status is 'none'
    queueObj = queueColl.findOne myQid 
    return status is queueObj.status




