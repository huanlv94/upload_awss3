class Upload
  include Mongoid::Document
  include Mongoid::Timestamps

  field :url, type: String
  field :job_id, type: String
  field :name, type: String
  field :type, type: String, default: 'video'
  field :key, type: String
  field :thumbnail, type: String
  field :status, type: String, default: 'PROGRESSING'
  field :subject, type: String
  field :message, type: String
  field :duration, type: Integer, default: 0
  field :sns_message_id, type: String

  before_save :check_completed

  def check_completed
    status = changes['status']

    unless status.blank?
      changed_value = status.last.downcase

      if %w(COMPLETE WARNING).include? changed_value
        self.url = link_buidler
        self.thumbnail = thumbnail_builder if type == 'video'
      end

    end
  end

  def self.create(job_id,aws_data)
    uploader = Upload.new
    uploader[:key] = aws_data[:key]
    uploader[:job_id] = job_id
    uploader[:url] = aws_data[:url]
    uploader[:name] = aws_data[:name]
    uploader[:type] = media_type_detecter(aws_data)

    uploader
  end

  def self.update_job(data)
    job = Upload.where(job_id: data[:job_id]).first
    user_upload = 'huanlv'

    if !job.blank? && !job.update(data)
      puts 'Loi transcoder !'
    end

    # Update realtime state of job
    TranscodingJob.perform_now(user_upload, job.as_json)

    job
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
