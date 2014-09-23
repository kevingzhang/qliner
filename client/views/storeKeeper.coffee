Template.storeKeeper.events
  'click .kickoff-btn': (e,t) ->
    qid = e.target.getAttribute 'data-qid'
    if qid?
      queueColl.update qid, $unset:{status:0}
    # ...

Template.storeKeeper.helpers
  role: () ->
    unless Meteor.userId()
      return 'not loggedin'
    console.log "this", @
    if (@storeInfo.access.admin.indexOf  Meteor.userId()) isnt -1
      return 'admin'
    if (@storeInfo.access.waiter.indexOf  Meteor.userId()) isnt -1
      return 'waiter'
    if (@storeInfo.access.staff.indexOf  Meteor.userId()) isnt -1
      return 'staff'
    return 'na' 

  displayFullName:()->
    if @usePhoneNumber
      return @usePhoneNumber
    if @useEmail
      return @useEmail
    return 'n/a'

  waitTime:()->
    nowTime = Session.get('nowTime')
    
    moment.duration(nowTime - @inTime).humanize()


    