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

      # private

      # # TODO: Write tests
      # def url=(url)
      #   if url.is_a?(URI)
      #     self.uri = url
      #     @url = url.path
      #   end

      #   if url.is_a?(String)
      #     self.uri = URI.parse(url)
      #     @url = uri.path
      #   end

      #   raise KType::Error, 'Web resource requires a url option' if @url.nil? || @url == ''
      # end
    end
  end
end
