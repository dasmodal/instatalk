jQuery(document).on 'turbolinks:load', ->
  App.presence = App.cable.subscriptions.create "PresenceChannel",
    connected: ->

    disconnected: ->

    received: (data) ->
      console.log('Received action: ' + data['action'])

      if data['action'] == 'append'
        received_id = $(data['content'])[0].id
      if $("##{received_id}").length == 0
        $('#presence_users').append $(data['content'])

      $(data['id']).remove() if data['action'] == 'remove'
