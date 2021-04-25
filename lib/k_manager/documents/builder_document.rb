# frozen_string_literal: true

module KManager
  module Documents
    class BuilderDocument
      include KLog::Logging
      include KManager::Documents::DocumentTaggable

      def initialize(**opts)
        initialize_document_tags(**opts)
      end

      # def default_document_type
      #   nil
      # end
    end
  end
end
