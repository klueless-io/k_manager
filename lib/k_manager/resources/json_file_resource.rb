# frozen_string_literal: true

module KManager
  module Resources
    # Represents a JSON file resource.
    class JsonFileResource < KManager::Resources::FileResource
      def initialize(**opts)
        super(**opts)
        @type = :json
      end
    end
  end
end
