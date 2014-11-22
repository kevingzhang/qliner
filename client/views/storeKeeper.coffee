Template.storeKeeper.events
  'click .listRow':(e,t)->
    qId = e.currentTarget.getAttribute 'data-qid'
    if qId?
      if Session.equals 'storeKeeper/selectedQid', qId
        Session.set 'storeKeeper/selectedQid', null
      else
        Session.set 'storeKeeper/selectedQid', qId
  'click .kickoff-btn': (e,t) ->
    qid = e.target.getAttribute 'data-qid'
    if qid?
      queueColl.update qid, $unset:{status:0}
    # ...
  'click .table-ready': (e,t)->
    qid = e.target.getAttribute 'data-qid'
    if qid?
      queueColl.update qid, $set:{status:'Table is ready'}

  'click .prepareing-table': (e,t)->
    qid = e.target.getAttribute 'data-qid'
    if qid?
      queueColl.update qid, $set:{status:'Preparing table'}

  'click .user-cancel': (e,t)->
    qid = e.target.getAttribute 'data-qid'
    if qid?
      queueColl.update qid, $set:{status:'User cancelled'}
      Meteor.setTimeout ()->
        queueColl.update qid, $unset:{status:0}
        , 5000

Template.storeKeeper.helpers
  role: () ->
    unless Meteor.userId()
      return 'not loggedin'
    console.log "this", @
    if (@storeInfo.access?.admin?.indexOf  Meteor.userId()) > -1
      return 'admin'
    if (@storeInfo.access?.waiter?.indexOf  Meteor.userId()) > -1
      return 'waiter'
    if (@storeInfo.access?.staff?.indexOf  Meteor.userId()) > -1
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

  isSelectedQid:(qId)->
    return if Session.equals('storeKeeper/selectedQid', qId) then "selected" else ''

    