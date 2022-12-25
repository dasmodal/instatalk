jQuery(document).on 'turbolinks:load', ->
  messages = $('#messages')

  $('#messages').animate({ scrollTop: $(document).height() }, 1200);

  if messages.length > 0
    App.cable.subscriptions.remove(App.room) if App.room
    createRoomChannel messages.data('room-id')

  $(document).on 'keypress', '#message_body', (event) ->
    message = event.target.value
    if event.keyCode is 13 && message != ''
      App.room.speak(message)
      event.target.value = ""
      event.preventDefault()

createRoomChannel = (roomId) ->
  App.room = App.cable.subscriptions.create {channel: "RoomChannel", roomId: roomId},
    connected: ->
      console.log('Connected to RoomChannel')

    disconnected: ->
      console.log('Disconnected from RoomChannel')

    received: (data) ->
      console.log('Received message: ' + data['message'])
      $('#messages').append data['message']
      $('#messages').animate({ scrollTop: $(document).height() }, 1200);

    speak: (message) ->
      if message != ""
        @perform 'speak', message: message 
