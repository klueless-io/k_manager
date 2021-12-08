# frozen_string_literal: true

module KManager
  module Overview
    class DumpJson
      attr_reader :path
      attr_reader :queries

      def initialize(path, manager)
        @path = path
        @queries = KManager::Overview::Queries.new(manager)
      end

      def areas(file_name)
        dump(file_name, queries.areas)
      end

      def resources(file_name)
        dump(file_name, queries.resources)
      end

      def documents(file_name)
        dump(file_name, queries.documents)
      end

      private

      def dump(file_name, data)
        file = File.join(path, file_name)
        json = JSON.pretty_generate(data)
        File.write(file, json)
      end
    end
  end
end
