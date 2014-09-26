Meteor.methods
  addMeInByPhoneNumber:(storeId, phoneNumber, email, partyOfNumber)->
    customerDoc = customerColl.findOne {phoneNumbers: phoneNumber}
    unless customerDoc?
      customerId = Meteor.call 'newCustomer', {phoneNumber:phoneNumber, email:email}
      customerDoc = customerColl.findOne customerId
    unless customerDoc?
      console.log 'ERROR: add new customer failed. By phone Number', phoneNumber 
      throw new Meteor.Error 'ERROR: add new customer failed. By phone Number'
    addInTime = new Date()
    displayFakeName = phoneNumber.slice(0,3) + '-XXX-XX' + phoneNumber.slice(phoneNumber.length - 2)
    queueId = queueColl.insert storeId:storeId, usePhoneNumber:phoneNumber, displayFakeName: displayFakeName, customer:customerDoc, partyOf:partyOfNumber, inTime:addInTime, status:'waiting'
    customerColl.update {_id:customerId}, $push:{inQueue:queueId}
    return {displayFakeName: displayFakeName, qId:queueId}

  addMeInByEmail:(storeId, email, partyOfNumber)->
    customerDoc = customerColl.findOne {emails: email}
    unless customerDoc?
      customerId = Meteor.call 'newCustomer', {email:email}
      customerDoc = customerColl.findOne customerId
    unless customerDoc?
      console.log 'ERROR: add new customer failed. By email', email 
      throw new Meteor.Error 'ERROR: add new customer failed. By phone Number'
    addInTime = new Date()
    atSignIndex = email.indexOf('@')
    displayFakeName = email.slice(0,3) + 'XXX@' + email.slice(atSignIndex, 3) + 'XXX' + email.slice(email.length - 4)
    queueId = queueColl.insert storeId:storeId, useEmail:email, displayFakeName:displayFakeName, customer:customerDoc, partyOf:partyOfNumber, inTime:addInTime, status:'waiting'
    customerColl.update {_id:customerId}, $push:{inQueue:queueId}
    return {displayFakeName: displayFakeName, qId:queueId}