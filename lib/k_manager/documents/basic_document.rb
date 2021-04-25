# frozen_string_literal: true

module KManager
  module Documents
    # A basic document stores a simple data object with tags for
    # unique key, type, namespace and project.
    class BasicDocument < KDoc::Container
      include KLog::Logging
      include KManager::Documents::DocumentTaggable

      def initialize(**opts)
        super(opts)
        initialize_document_tags(**opts)
      end

      def default_document_type
        :basic
      end
    end
  end
end
