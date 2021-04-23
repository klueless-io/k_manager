# frozen_string_literal: true

module KManager
  module Resources
    # Represents a YAML file resource.
    class YamlFileResource < KManager::Resources::FileResource
      def initialize(**opts)
        super(**opts)
        @type = :yaml
      end

      # Maybe this gets done in a lower level
      def register_document
        @document = super
      end

      def load_document
        data = YAML.safe_load(content)
        @document.data = data
      end

      #         def debug
      #           L.ostruct(KDsl::Util.data.to_struct(@document.data))
      #         end
    end
  end
end
