Meteor.methods
  addMeInByPhoneNumber:(storeId, phoneNumber, partyOfNumber)->
    customerDoc = customerColl.findOne {phoneNumbers: phoneNumber}
    unless customerDoc?
      customerId = Meteor.call 'newCustomer', {phoneNumber:phoneNumber}
      customerDoc = customerColl.findOne customerId
    unless customerDoc?
      console.log 'ERROR: add new customer failed. By phone Number', phoneNumber 
      throw new Meteor.Error 'ERROR: add new customer failed. By phone Number'
    addInTime = new Date
    queueId = queueColl.insert storeId:storeId, customer:customerDoc, partyOf:partyOfNumber, inTime:addInTime, status:'waiting'
    customerColl.update {_id:customerId}, $push:{inQueue:queueId}
