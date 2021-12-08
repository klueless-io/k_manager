# frozen_string_literal: true

module KManager
  module Resources
    require 'handlebars/helpers/string_formatting/dasherize'

    # TODO, turn into a module

    # A web resource represents content that is loaded via a web URI.
    #
    # Web resources do not support watchers and so if you want to handle
    # content changes then you will either need to poll the resource periodically
    # or have a server with open channel for web-hooks.
    class WebResource < KManager::Resources::BaseResource
      include KLog::Logging

      attr_reader :source

      # NAMESPACE ???
      def initialize(**opts)
        super(**opts)

        guard
      end

      # class << self
      #   def instance(**opts)
      #     content_type = opts[:content_type]

      #     case content_type
      #     when 'rb'
      #       KManager::Resources::RubyWebResource.new(**opts)
      #     when 'csv'
      #       KManager::Resources::CsvWebResource.new(**opts)
      #     when 'json'
      #       KManager::Resources::JsonWebResource.new(**opts)
      #     when 'yaml'
      #       KManager::Resources::YamlWebResource.new(**opts)
      #     else
      #       KManager::Resources::UnknownWebResource.new(**opts)
      #     end
      #   end
      # end

      # Infer key is the file name without the extension stored in dash-case
      def infer_key
        file_name = Pathname.new(@file).basename.sub_ext('').to_s
        Handlebars::Helpers::StringFormatting::Snake.new.parse(file_name)
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

      # Currently in base
      # def register_document
      #   attach_document(create_document)
      # end

      # rubocop:disable  Metrics/AbcSize
      def debug
        log.section_heading('resource')
        log.kv 'source'   , @source , 15
        log.kv 'file'     , file                                                  , 15
        log.kv 'type'     , type                                                  , 15
        log.kv 'infer_key', infer_key                                             , 15
        log.kv 'status'   , status                                                , 15
        # log.kv 'project'  , project
        log.kv 'content'  , content.nil? ? '' : content[0..100].gsub("\n", '\n')  , 15
        log.kv 'documents', documents.length                                      , 15

        documents.each(&:debug)
      end
      # rubocop:enable  Metrics/AbcSize

      private

      def guard
        raise KType::Error, 'File resource requires a file option' if @file.nil? || @file == ''
      end
    end
  end
end
