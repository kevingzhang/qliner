Meteor.methods
  
  dbInit:()->
    counterColl.insert {_id:'store', curId:0}
    counterColl.insert {_id:'customer', curId:0}