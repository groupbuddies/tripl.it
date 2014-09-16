Template.signIn.helpers
  emailAttributes: ->
    {
      type: "email"
      name: "email"
      placeholder: "Type your email here..."
    }

  passwordAttributes: ->
    {
      type: 'password'
      name: 'password'
      placeholder: 'Type your password here...'
    }

Template.signIn.submit = ->
  email = $('#email').val()
  password = $('#password').val()
  Meteor.loginWithPassword(email, password, (err) ->
    if err
      console.log(err)
    else
      Router.go 'tripsIndex'
  )

Template.signIn.events
  'submit': (e) ->
    e.preventDefault()
    Template.signIn.submit()
