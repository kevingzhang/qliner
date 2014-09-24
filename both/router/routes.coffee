

Router.configure
  layoutTemplate: 'MasterLayout'
  loadingTemplate: 'Loading'
  notFoundTemplate: 'NotFound'
  templateNameConverter: 'upperCamelCase'
  routeControllerNameConverter: 'upperCamelCase'

Router.map ()->
  @route 'home',
    path:'/'

  @route 'store',
    path:'/store/:storeId',
    waitOn:()->
      h1 = Meteor.subscribe 'storeInfo', @params.storeId
      h2 = Meteor.subscribe 'storeQueue', @params.storeId
      return [h1,h2]
    data:()->
      storeInfo = storeColl.findOne @params.storeId
      storeQueue = queueColl.find storeId:@params.storeId

      return {
              storeInfo : storeInfo
              storeQueue: storeQueue}
  @route 'storeKeeper',
    path: 'storekeeper'
    template: 'storeKeeperSelector'
    onBeforeAction: (pause)->
      unless Meteor.user()
        @render 'login'
        pause()
  @route 'storeKeeper',
    path: 'storekeeper/:storeId'
    onBeforeAction: (pause)->
      unless Meteor.user()?
        @render 'login'
        pause()

    waitOn:()->
      h1 = Meteor.subscribe 'storeInfo', @params.storeId
      h2 = Meteor.subscribe 'storeQueue', @params.storeId
      return [h1,h2]
    data:()->
      
      storeInfo = storeColl.findOne @params.storeId
      storeQueue = queueColl.find storeId:@params.storeId

      return {
              storeInfo : storeInfo
              storeQueue: storeQueue}
    action:()->
      if @ready()
        @render()
      else

  @route 'admin',
    path:'/admin'
