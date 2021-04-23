# frozen_string_literal: true

require 'csv'

module KManager
  module Resources
    # Represents a CSV file resource.
    class CsvFileResource < KManager::Resources::FileResource
      def initialize(**opts)
        super(**opts)
        @type = :csv
      end

      def load_document
        data = []
        CSV.parse(content, headers: true, header_converters: :symbol).each do |row|
          data << row.to_h
        end
        @document.data = data
      end

      # def debug
      #   tp @document.data, @document.data.first.to_h.keys
      # end
    end
  end
end
