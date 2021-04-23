# frozen_string_literal: true

module KManager
  module Resources
    # Represents a Ruby file resource.
    class RubyFileResource < KManager::Resources::FileResource
      def initialize(**opts)
        super(**opts)
        @type = :ruby
      end

      def register_document
        @document = super
      end
    end
  end
end
