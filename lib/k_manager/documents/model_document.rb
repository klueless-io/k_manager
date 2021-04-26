# frozen_string_literal: true

module KManager
  module Documents
    class ModelDocument < KDoc::Model
      include KLog::Logging
      include KManager::Documents::DocumentTaggable

      def initialize(**opts)
        super(**opts)
        initialize_document_tags(**opts)
      end

      def default_document_type
        KDoc.opinion.default_model_type
      end
    end
  end
end
