# frozen_string_literal: true

module KManager
  module Resources
    require 'handlebars/helpers/string_formatting/dasherize'

    # A file resource represents context that is loaded via a file.
    #
    # File resources have the benefit that file watchers can watch them
    # locally and reload these resources on change.
    class FileResource < KManager::Resources::BaseResource
      include KLog::Logging

      # Full path to file
      #
      # example: /Users/davidcruwys/dev/kgems/k_dsl/spec/factories/dsls/common-auth/admin_user.rb
      attr_reader :file

      def initialize(**opts)
        super(**opts)
        @source = :file
        @file = opts[:file]

        guard
      end

      class << self
        def instance(**opts)
          file = opts[:file]

          extension = ::File.extname(file).downcase

          case extension
          when '.rb'
            KManager::Resources::RubyFileResource.new(**opts)
          when '.csv'
            KManager::Resources::CsvFileResource.new(**opts)
          when '.json'
            KManager::Resources::JsonFileResource.new(**opts)
          when '.yaml'
            KManager::Resources::YamlFileResource.new(**opts)
          else
            KManager::Resources::UnknownFileResource.new(**opts)
          end
        end
      end

      # Infer key is the file name without the extension stored in dash-case
      def infer_key
        file_name = Pathname.new(@file).basename.sub_ext('').to_s
        Handlebars::Helpers::StringFormatting::Dasherize.new.parse(file_name)
      end

      def load_content
        if File.exist?(file)
          begin
            @content = File.read(file)
          rescue StandardError => e
            log.error e
          end
        else
          log.error "Source file not found: #{file}"
        end
      end

      def register_document
        attach_document(create_document)
      end

      private

      def guard
        raise KType::Error, 'File resource requires a file option' if @file.nil? || @file == ''
      end
    end
  end
end
