# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class NotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'notification_channel'
  end

  # Any cleanup needed when channel is unsubscribed
  def unsubscribed; end

  def notify(data)
    ActionCable.server.broadcast 'notification_channel', { message: data['message'] }
  end
end