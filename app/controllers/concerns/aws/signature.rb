class AwsServices
  class Signature
    class << self
      ALGORITHM = 'AWS4-HMAC-SHA256'.freeze
      STATUS_CODE = '201'.freeze
      REQUEST_TYPE = 'aws4_request'.freeze
      SERVICE = 's3'.freeze

      def generate(bucket)
        date = DateTime.now.strftime('%Y%m%dT%H%M%SZ')
        short_date = DateTime.now.strftime('%Y%m%d')
        credential = "#{AWS_ACCESS_KEY_ID}/#{short_date}/#{REGION}/#{SERVICE}/#{REQUEST_TYPE}"

        policy = signature_policy(credential, date, bucket)
        signature = hmac_signature(policy, short_date)

        signature_builder(policy, credential, date, signature, short_date)
      end

      private

      def hmac_signature(policy, short_date)
        k_date    = OpenSSL::HMAC.digest('sha256', "AWS4#{AWS_SECRET_ACCESS_KEY}", short_date)
        k_region  = OpenSSL::HMAC.digest('sha256', k_date, REGION)
        k_service = OpenSSL::HMAC.digest('sha256', k_region, SERVICE)
        k_signing = OpenSSL::HMAC.digest('sha256', k_service, REQUEST_TYPE)

        OpenSSL::HMAC.hexdigest('sha256', k_signing, policy)
      end

      def signature_policy(credential, date, bucket)
        expiration = (Time.now + 3.days).strftime('%Y-%m-%dT%H:%M:%SZ')
        policy = {
          'expiration' => expiration,
          'conditions' => policy_condition(credential, date, bucket)
        }

        Base64.encode64(policy.to_json).remove("\n")
      end

      def signature_builder(policy, credential, date, signature, short_date)
        { 'content-type' => '',
          'acl' => ACL,
          'success_action_status' => STATUS_CODE,
          'policy' => policy,
          'x-amz-credential' => credential,
          'x-amz-algorithm' => ALGORITHM,
          'x-amz-date' => date,
          'x-amz-signature' => signature,
          'short_date' => short_date }
      end

      def policy_condition(credential, date, bucket)
        [
          { 'bucket' => bucket },
          { 'acl' => ACL  },
          ['starts-with', '$key', ''],
          ['starts-with', '$content-type', ''],
          { 'success_action_status' => STATUS_CODE },
          { 'x-amz-credential' => credential },
          { 'x-amz-algorithm' => ALGORITHM },
          { 'x-amz-date' => date }
        ]
      end
    end
  end
end
