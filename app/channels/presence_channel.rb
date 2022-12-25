class PresenceChannel < ApplicationCable::Channel
  def subscribed
    logger.info 'Subscribed to PresenceChannel'

    current_user.update(online: true)
    stream_from "presence_channel"
    broadcast_presence_append
  end

  def unsubscribed
    logger.info 'Unsubscribed to PresenceChannel'

    if users_connections_count.zero?
      current_user.update(online: false)
      broadcast_presence_remove
    end
  end

  private

  def users_connections_count
    ActionCable.server.connections.count { |connect| connect.current_user == current_user }
  end

  def broadcast_presence_append
    ActionCable.server.broadcast 'presence_channel', {
      action: 'append',
      content: ApplicationController.renderer.render(
        partial: 'users/user',
        locals:  {
          user: current_user
        })
    }
  end

  def broadcast_presence_remove
    ActionCable.server.broadcast 'presence_channel', {
      action: 'remove',
      id: "#user#{current_user.id}"
    }
  end
end
