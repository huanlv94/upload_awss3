class Upload
  include Mongoid::Document
  include Mongoid::Timestamps

  field :url, type: String
  field :name, type: String
  field :type, type: String, default: 'video'
  field :key, type: String
  field :thumbnail, type: String

  def self.create(aws_data)
    uploader = Upload.new
    uploader[:key] = aws_data[:key]
    uploader[:url] = aws_data[:url]
    uploader[:name] = aws_data[:name]
    uploader[:type] = media_type_detecter(aws_data)

    uploader
  end

  def link_buidler
    final_link = ''

    if type == 'video'
      key = self.key.remove('.')

      final_link = "#{CLOUD_FRONT_DOMAIN}/#{key}master.m3u8"
    elsif type == 'audio'
      final_link = "#{CDN_AUDIO}/#{self.key}"
    elsif type == 'image'
      final_link = "#{CDN_IMAGE}/#{self.key}"
    elsif type == 'document'
      final_link = "#{CDN_DOCUMENT}/#{self.key}"
    end

    final_link
  end

  def thumbnail_builder
    thumbnail = ''

    if type == 'video'
      key = self.key.remove('.')

      thumbnail = "#{CLOUD_THUMB_DOMAIN}/#{key}thumb_720_00001.png"
    else
      thumbnail = origin_link
    end

    thumbnail
  end

  def self.media_type_detecter(aws_data)
    media_type = 'other'

    if aws_data[:bucket] == BUCKET_VIDEO
      media_type = 'video'
    elsif aws_data[:bucket] == BUCKET_AUDIO
      media_type = 'audio'
    elsif aws_data[:bucket] == BUCKET_IMAGE
      media_type = 'image'
    elsif aws_data[:bucket] == BUCKET_DOCUMENT
      media_type = 'document'
    end

    media_type
  end
end
