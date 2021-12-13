# frozen_string_literal: true

require 'securerandom'

module KManager
  module Resources
    require 'handlebars/helpers/string_formatting/dasherize'

    # A memory resource represents content that is generated programmatically and just stored in memory.
    class MemResource < KManager::Resources::BaseResource
      def initialize(**opts)
        fake_uri = URI.parse("mem://#{SecureRandom.alphanumeric(4)}")
        super(fake_uri, **opts)
      end
    end
  end
end
 
