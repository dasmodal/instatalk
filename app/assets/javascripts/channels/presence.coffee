jQuery(document).on 'turbolinks:load', ->
  App.presence = App.cable.subscriptions.create 'PresenceChannel',
    connected: ->

    disconnected: ->

    received: (data) ->
      users = data['users'].map (user) -> "<li>#{user.nickname}</li>"

      $('#presence_users').html(users.join(''))
