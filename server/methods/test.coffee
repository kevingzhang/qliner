Meteor.methods
  "AddFakeUser": (storeId, count)->
    #@unblock()
    CreateFakeUser = ()->
      phoneNumber = (Math.random() * 100000000000000).toString().slice(0,10)
      emailDomain = Fake.fromArray(['@gmail.com', '@hotmail.com', '@icloud.com', '@yahoo.com', '@something.com'])
      email = Fake.word() + emailDomain
      partyOf = Fake.fromArray([2,1,5,3,6,8,7,4])
      console.log "going to add new fake user #{phoneNumber}, #{email}, #{partyOf}"
      Meteor.call 'addMeInByPhoneNumber', storeId, phoneNumber, email, partyOf 
      count -= 1
      if count >0
        console.log "count is #{count }"
        Meteor.setTimeout CreateFakeUser, Math.round(Math.random()*10000)
        return ''
    
    Meteor.setTimeout CreateFakeUser ,Math.round(Math.random()*10000)
    return ''

