# frozen_string_literal: true

module KManager
  # Alow existing documents from KDoc and other sources to be imported using the resource manager
  module DocumentImport
    module Extension
      include KLog::Logging

      def import(tag)
        # KManager.find_document(tag)
      end
    end
  end
end

KDoc::Action.include(KManager::DocumentImport::Extension)
KDoc::Model.include(KManager::DocumentImport::Extension)
KDoc::CsvDoc.include(KManager::DocumentImport::Extension)
KDoc::JsonDoc.include(KManager::DocumentImport::Extension)
KDoc::YamlDoc.include(KManager::DocumentImport::Extension)
