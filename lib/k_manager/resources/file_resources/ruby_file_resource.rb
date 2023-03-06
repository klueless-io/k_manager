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
        KManager.target_resource = self

        Object.class_eval content

      # rescue StandardError => exception
      #   # Report the error but still add the document so that you can see
      #   # it in the ResourceDocument list, it will be marked as Error
      #   resource.error = exception

      #   L.exception resource.error
      ensure
        KManager.target_resource = nil

        # A regular ruby file would not add resource_documents
        # so create one manually
        @document = super if documents.empty?
      end
    end
  end
end
