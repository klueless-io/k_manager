# frozen_string_literal: true

module KManager
  # Allow existing documents from KDoc and other sources to be imported using the resource manager
  module DocumentImport
    # Find a document by tag for importing
    class Importer
      def import(tag, area: nil)
        KManager.find_document(tag, area: area)
      end
    end
  end
end
