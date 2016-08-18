# Be sure to restart your server when you modify this file.
# Action Cable runs in a loop that does not support auto reloading.
class TranscodingChannel < ApplicationCable::Channel
  def subscribed
    stream_from "transcoding_channel_#{params['user_upload']}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
