# frozen_string_literal: true

module KManager
  module Resources
    # Represents a YAML file resource.
    class YamlFileResource < FileResource
      def initialize(**opts)
        super(**opts)
        @type = :yaml
      end
    end
  end
end
