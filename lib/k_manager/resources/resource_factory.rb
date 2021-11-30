# frozen_string_literal: true

module KManager
  module Resources
    class ResourceFactory
      # Create a resource based on a resource URI.
      #
      # Resources may be of type File or Web
      #
      # The resource content_type should be passed in when it cannot be inferred (e.g. WebResource)
      # for a FileResource this option is optional and will be inferred from the file extension.
      def instance(resource_uri, content_type: nil)
        scheme = resource_uri.scheme.to_sym

        case scheme
        when :file
          create_file_resource(resource_uri)
        when :http, :https
          create_web_resource(resource_uri)
        else
          raise 'Unknown schema'
        end
      end

      private

      def create_web_resource(uri)
        WebResource.new(uri.path) # state: :alive
      end

      def create_file_resource(uri)
        FileResource.new(uri.path) # state: :alive
      end

      # class << self
      #   def from_files(fileset)
      #     fileset.path_entries.map { |path_entry| FileResource.instance(path_entry.to_s) }
      #   end

      #   def from_uris(uri_set)
      #     uri_set.uris.map { |uri| WebResource.instance(uri.to_s) }
      #   end
      # end
    end
  end
end
