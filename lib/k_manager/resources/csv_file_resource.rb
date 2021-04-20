# frozen_string_literal: true

module KManager
  module Resources
    # Represents a CSV file resource.
    class CsvFileResource < KManager::Resources::FileResource
      def initialize(**opts)
        super(**opts)
        @type = :csv
      end
    end
  end
end
