Meteor.methods
  newCustomer:(options)->
    
    #user add using his phone phoneNumber
    newCustomerDoc = {}
    if options.phoneNumber?
      newCustomerDoc.phoneNumbers = [options.phoneNumber]
    if options.email?
      newCustomerDoc.emails = [options.email]
    if Object.getOwnPropertyNames(newCustomerDoc).length is 0
      console.log "ERROR: new customer should either has phone number or email address"
      return 
    customerId = customerColl.insert newCustomerDoc
    return customerId