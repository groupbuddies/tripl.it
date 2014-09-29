Router.configure
  layoutTemplate: 'layout'

beforeHooks =
  isLoggedIn: ->
    if !Meteor.userId()
      Router.go 'signIn'

  resetNavigationVent: ->
    NavigationVent.reset()

Router.onBeforeAction(beforeHooks.resetNavigationVent)
Router.onBeforeAction(beforeHooks.isLoggedIn, { except: [ 'signIn', 'signUp', 'lab' ] })

Router.map ->
  @route 'tripsIndex',
    path: '/'
    waitOn: ->
      Meteor.subscribe 'trips'
    data: ->
      Trips.find {}, transform: (doc) ->
        doc['path'] = Router.path('tripsShow', { _id: doc._id })
        return doc

  @route 'tripsAdd',
    path: 'trips/new'

  @route 'tripsShow',
    layoutTemplate: 'layoutWithHeader'
    path: 'trip/:_id'
    waitOn: ->
      return [
        Meteor.subscribe 'trip', @params._id
        Meteor.subscribe 'expenses', @params._id
      ]
    data: ->
      return Trips.findOne @params._id, transform: (trip) ->
          trip['expenses'] = Expenses.find {tripId: trip._id}
          trip['currentBudget'] = 0
          trip['expenses'].map (expense) ->
            trip['currentBudget'] += parseInt(expense.value)
          return trip

  @route 'usersNew',
    path: 'trip/:_id/users/new'
    waitOn: ->
      Meteor.subscribe 'users'

  @route 'signUp',
    path: 'sign_up'

  @route 'signIn',
    path: 'sign_in'

  @route 'signOut',
    path: 'sign_out'
    action: ->
      Meteor.logout()

  @route 'budgetNew',
    path: 'trip/:_id/budget/new'

  @route 'expenseNew',
    path: 'trip/:_id/expenses/new'
    waitOn: ->
      Meteor.subscribe 'trip', @params._id

  @route 'lab',
    path: 'lab'
