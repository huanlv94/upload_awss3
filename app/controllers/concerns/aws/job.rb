class AwsServices
  class Job
    class << self
      def generate(key)
        sub = key.delete('.')

        {
          pipeline_id: PIPELINE, # required
          input: { key: key }, # required
          outputs: generate_outputs(sub),
          output_key_prefix: sub,
          playlists: generate_playlist(sub)
        }
      end

      private

      def generate_outputs(sub)
        [generate_1080(sub), generate_720(sub), generate_480(sub), generate_360(sub)]
      end

      def generate_playlist(sub)
        [
          {
            name: 'master',
            format: 'HLSv3',
            output_keys: [sub + '_1080_', sub + '_720_', sub + '_480_', sub + '_360_'],
            hls_content_protection: { method: 'aes-128', key_storage_policy: 'WithVariantPlaylists' }
          }
        ]
      end

      def generate_1080(sub)
        {
          key: sub + '_1080_',
          thumbnail_pattern: 'thumb_1080_{count}',
          preset_id: PRESET_1080,
          segment_duration: '5'
        }
      end

      def generate_720(sub)
        {
          key: sub + '_720_',
          thumbnail_pattern: 'thumb_720_{count}',
          preset_id: PRESET_720,
          segment_duration: '5'
        }
      end

      def generate_480(sub)
        {
          key: sub + '_480_',
          thumbnail_pattern: 'thumb_480_{count}',
          preset_id: PRESET_480,
          segment_duration: '5'
        }
      end

      def generate_360(sub)
        {
          key: sub + '_360_',
          thumbnail_pattern: 'thumb_360_{count}',
          preset_id: PRESET_360,
          segment_duration: '5'
        }
      end
    end
  end
end
