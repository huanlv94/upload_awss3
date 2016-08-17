require 'aws-sdk'

AWS_ACCESS_KEY_ID = 'AKIAIZIQC7CNV6SVX3HA'.freeze
AWS_SECRET_ACCESS_KEY = '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'.freeze
REGION = 'ap-southeast-1'.freeze
PRESET_360 = '1443412771848-awxfos'.freeze
PRESET_480 = '1443008700209-mit687'.freeze
PRESET_720 = '1443411895894-efbdge'.freeze
PRESET_1080 = '1439968464247-vlfgyk'.freeze
PIPELINE = '1467280376904-vsgkao'.freeze
CLOUD_FRONT_DOMAIN = '//d30tmglcpl3zip.cloudfront.net'.freeze
CLOUD_THUMB_DOMAIN = '//d2ekpuzm5xasyv.cloudfront.net'.freeze
CDN_DOCUMENT = '//d2p7vumjmtlqyx.cloudfront.net'.freeze
CDN_IMAGE = '//d2ggz0t4nq5div.cloudfront.net'.freeze
CDN_AUDIO = '//dmrslzmkemcv6.cloudfront.net'.freeze
BUCKET_VIDEO = 'zofy-lecture-video'.freeze
BUCKET_AUDIO = 'zofy-audio'.freeze
BUCKET_IMAGE = 'zofy-image'.freeze
BUCKET_DOCUMENT = 'zofy-document'.freeze
ACL = 'public-read'.freeze
ARN_KEY = 'arn:aws:kms:ap-southeast-1:350339004156:key/a09067c3-171b-4a8f-9752-31581a566134'.freeze

# Aws.config(
#   :access_key_id => AWS_ACCESS_KEY_ID,
#   :secret_access_key => AWS_SECRET_ACCESS_KEY
# )

credentials = Aws::Credentials.new(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)

# S3_BUCKET =  Aws::S3.new.buckets[ENV['zofy-lecture-video']]
# Initialize
Aws.config[:region] = REGION
Aws.config[:credentials] = credentials
# s3_client = Aws::S3::Client.new
# get all buckets
# buckets = s3.list_buckets
# array name buckets
# buckets.buckets.map(&:name)
# get two object from bucket
# keys = s3.list_objects(bucket: 'pedia-lecture-video', max_keys: 2)
# keys.contents.each do |object|
#   puts "#{object.key} => #{object.etag}"
# end
S3 = Aws::S3::Resource.new
# Define bucket for pedia-lecture-video to upload
BUCKET = S3.bucket(BUCKET_VIDEO)
# Init KMS
KMS = Aws::KMS::Client.new(region: REGION, credentials: credentials)

# define transcoder
TRANSCODER = Aws::ElasticTranscoder::Client.new(
  region: REGION,
  credentials: credentials
)
