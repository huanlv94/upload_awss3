require 'aws/signature'
require 'aws/job'

class AwsServices
  class << self
    def generate_signature
      signature = {}
      signature[:video] = AwsServices::Signature.generate(BUCKET_VIDEO)
      signature[:image] = AwsServices::Signature.generate(BUCKET_IMAGE)
      signature[:audio] = AwsServices::Signature.generate(BUCKET_AUDIO)
      signature[:document] = AwsServices::Signature.generate(BUCKET_DOCUMENT)

      signature
    end

    def generate_job(key)
      AwsServices::Job.generate(key)
    end
  end
end
