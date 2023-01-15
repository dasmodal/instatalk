class PresenceChannel < ApplicationCable::Channel
  def subscribed
    logger.info 'Subscribed to PresenceChannel'

    current_user.update(online: true)
    stream_from 'presence_channel'
    broadcast_presence_users
  end

  def unsubscribed
    logger.info 'Unsubscribed to PresenceChannel'

    return unless users_connections_count.zero?

    current_user.update(online: false)
    broadcast_presence_users
  end

  private

  def users_connections_count
    ActionCable.server.connections.count { |connect| connect.current_user == current_user }
  end

  def broadcast_presence_users
    ActionCable.server.broadcast 'presence_channel', users: User.online
  end
end
