# frozen_string_literal: true

module KManager
  module Resources
    # Represents a YAML file resource.
    class YamlFileResource < KManager::Resources::FileResource
      def initialize(**opts)
        super(**opts)
        @type = :yaml
      end

      def load_document
        data = YAML.safe_load(content)
        document.data = data
      end

      #         def debug
      #           L.ostruct(KDsl::Util.data.to_struct(self.document.data))
      #         end
    end
  end
end
