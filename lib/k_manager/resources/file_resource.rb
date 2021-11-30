# frozen_string_literal: true

module KManager
  module Resources
    # A file resource represents content that is loaded via a file.
    #
    # File resources have the benefit that file watchers can watch them
    # locally and reload when these resources on change.
    class FileResource < KManager::Resources::BaseResource
      include KLog::Logging

      # TODO: This needs to be a readonly method that utilises the URI
      # Full path to file
      #
      # example: /Users/davidcruwys/dev/kgems/k_dsl/spec/factories/dsls/common-auth/admin_user.rb
      attr_reader :file

      # NAMESPACE can probably be taken from file set relative path
      def initialize(**opts)
        self.file = opts[:file]

        @content_type = opts[:content_type] || infer_content_type

        super(**opts)
      end

      # Infer key is the file name without the extension stored in dash-case
      def infer_key
        file_name = Pathname.new(file).basename.sub_ext('').to_s
        Handlebars::Helpers::StringFormatting::Dasherize.new.parse(file_name)
      end

      # def register_document
      #   # attach_document(create_document)
      # end

      def debug
        super do
          log.kv 'infer_key'        , infer_key          , 20
          log.kv 'file'             , file               , 20
          log.kv 'resource_path'    , resource_path      , 20
          log.kv 'resource_valid?'  , resource_valid?    , 20
        end
      end

      def default_scheme
        :file
      end

      def resource_path
        @resource_path ||= absolute_path(@file)
      end

      def resource_valid?
        File.exist?(resource_path)
      end

      private

      def load_content
        if resource_valid?
          begin
            @content = File.read(resource_path)
          rescue StandardError => e
            log.error e
          end
        else
          log.error "Source file not found: #{resource_path}"
        end
      end

      def file=(file)
        if file.is_a?(URI)
          self.uri = file
          @file = file.path
        end

        if file.is_a?(String)
          self.uri = URI::File.build(host: nil, path: absolute_path(file))
          @file = uri.path
        end

        raise KType::Error, 'File resource requires a file option' if @file.nil? || @file == ''
      end

      def absolute_path(path)
        pn = Pathname(path)

        pn.exist? ? pn.realpath.to_s : File.expand_path(path)
      end

      def infer_content_type
        extension = ::File.extname(file).downcase
        case extension
        when '.rb'
          :ruby
        when '.csv'
          :csv
        when '.json'
          :json
        when '.yaml'
          :yaml
        end
      end
    end
  end
end
