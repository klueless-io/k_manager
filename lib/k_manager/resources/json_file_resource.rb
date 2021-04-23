# frozen_string_literal: true

module KManager
  module Resources
    # Represents a JSON file resource.
    class JsonFileResource < KManager::Resources::FileResource
      def initialize(**opts)
        super(**opts)
        @type = :json
      end

      def load_document
        data = JSON.parse(content)
        @document.data = data
      end

      # def debug
      #   L.ostruct(KDsl::Util.data.to_struct(@document.data))
      # end
    end
  end
end
