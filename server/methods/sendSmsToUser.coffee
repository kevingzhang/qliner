Meteor.methods
  "sendSmsToUser":(phoneNumber)->
    ACCOUNT_SID = process.env.TWILIO_ACCOUNT_SID 
    AUTH_TOKEN = process.env.TWILIO_AUTH_TOKEN

    console.log "#{ACCOUNT_SID}, #{AUTH_TOKEN}"
    return 
    twilio = Twilio ACCOUNT_SID, AUTH_TOKEN
    options = {
      to:phoneNumber, #// Any number Twilio can deliver to
      from: '+14084007678', #// A number you bought from Twilio and can use for outbound communication
      body: 'word to your mother.' #// body of the SMS message
    }
    console.log "going to send sms"
    twilio.sendSms options, (err, responseData) ->
      # //this function is executed when a response is received from Twilio
      console.log "#{JSON.stringify err}, #{JSON.stringify responseData}"
      unless err  #// "err" is an error received during the request, if any
        #// "responseData" is a JavaScript object containing data received from Twilio.
        
        #// A sample response from sending an SMS message is here (click "JSON" to see how the data appears in JavaScript):
        
        #// http://www.twilio.com/docs/api/rest/sending-sms#example-1
        console.log(responseData.from); #// outputs "+14506667788"
        console.log(responseData.body); #// outputs "word to your mother."
      