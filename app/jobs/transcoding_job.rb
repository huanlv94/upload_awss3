class TranscodingJob < ApplicationJob
  queue_as :default

  def perform(user_upload, data)
    ActionCable.server.broadcast "transcoding_channel_#{user_upload}", data
  end
end
