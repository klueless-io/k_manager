# frozen_string_literal: true

module KManager
  module Resources
    # A file resource represents content that is loaded via a file.
    #
    # File resources have the benefit that file watchers can watch them
    # locally and reload when these resources on change.
    class FileResource < KManager::Resources::BaseResource
      include KLog::Logging

      KNOWN_EXTENSIONS = {
        '.rb' => :ruby,
        '.csv' => :csv,
        '.json' => :json,
        '.yaml' => :yaml
      }.freeze

      # Real path - aka Full path to file
      #
      # example: /Users/davidcruwys/dev/kgems/k_dsl/spec/factories/dsls/common-auth/admin_user.rb
      def source_path
        uri.path
      end

      # TODO: Write tests
      def recreate(resource)
        raise 'Recreate only works for resources of the same type' unless resource.is_a?(self.class)

        # area: resource.area,
        # content_type: resource.content_type,
        opts = {
          namespace: resource.namespace,
          file: resource.file
        }

        resource.class.new(opts)
      end

      # Infer key is the file name without the extension stored in dash-case
      def infer_key
        file_name = Pathname.new(source_path).basename.sub_ext('').to_s
        Handlebars::Helpers::StringFormatting::Snake.new.parse(file_name)
      end

      # Currently in base
      # def register_document
      #   KManager::Resources::ResourceDocumentFactory.create_documents(self)
      # end

      def debug
        super do
          log.kv 'infer_key'        , infer_key , 20
          log.kv 'file'             , source_path          , 20
          log.kv 'resource_path'    , resource_path      , 20
          log.kv 'resource_valid?'  , resource_valid?    , 20
        end
      end

      def attribute_values(prefix = nil)
        result = super(prefix)
        result["#{prefix}scheme".to_sym]        = scheme
        result["#{prefix}path".to_sym]          = resource_path
        result["#{prefix}relative_path".to_sym] = resource_relative_path
        result["#{prefix}exist".to_sym]         = resource_valid?
        result
      end

      def default_scheme
        :file
      end

      def resource_path
        @resource_path ||= absolute_path(source_path)
      end

      def resource_relative_path(from_path = Dir.pwd)
        Pathname.new(resource_path).relative_path_from(from_path).to_s
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
          guard("Source file not found: #{resource_path}")
        end
      end

      # def file=(file)
      #   if file.is_a?(URI)
      #     self.uri = file
      #     @file = file.path
      #   end

      #   if file.is_a?(String)
      #     self.uri = URI::File.build(host: nil, path: absolute_path(file))
      #     @file = uri.path
      #   end

      #   raise KType::Error, 'File resource requires a file option' if @file.nil? || @file == ''
      # end

      def absolute_path(path)
        pn = Pathname(path)

        pn.exist? ? pn.realpath.to_s : File.expand_path(path)
      end

      def infer_content_type
        extension = ::File.extname(source_path).downcase
        KNOWN_EXTENSIONS[extension]
      end
    end
  end
end
