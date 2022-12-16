# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class UpdateChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'update_channel'
  end

  # Any cleanup needed when channel is unsubscribed
  def unsubscribed; end

  def notify(data)
    ActionCable.server.broadcast 'update_channel', { ids: data['ids'] }
  end
end