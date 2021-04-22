# frozen_string_literal: true

module KManager
  module Resources
    # Represents a CSV file resource.
    class CsvFileResource < KManager::Resources::FileResource
      def initialize(**opts)
        super(**opts)
        @type = :csv
      end

      def register_document
        # log.kv 'Key', infer_key
        # log.kv 'Type', @type
        # Need to support file namespaces, but to do that you need to have a root namespace defined that
        # would limit the size of the namespace and currently I need more information before that can happen
        # log.kv 'Namespace', ''
        # log.kv 'Project Key', project&.infer_key

        container = KDoc::Container.new(key: infer_key, type: type, namespace: '', project_key: project&.infer_key)

        log.kv 'Unique Key', container.unique_key

        add_document(container)
      end
    end
  end
end
