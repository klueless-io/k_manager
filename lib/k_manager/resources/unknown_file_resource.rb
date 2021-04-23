# frozen_string_literal: true

module KManager
  module Resources
    # Represents a Unknown file resource.
    class UnknownFileResource < KManager::Resources::FileResource
      def initialize(**opts)
        super(**opts)
        @type = :unknown
      end

      def register_document
        @document = super
      end

      def load_document
        @document.data = {}
      end

      # def debug
      #   L.warn 'unknown document'
      #   L.info content
      # end
    end
  end
end
