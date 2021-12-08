# frozen_string_literal: true

module KManager
  module Resources
    class ResourceFactory
      # TODO: Write tests

      # Create a resource based on a resource URI.
      #
      # Resources may be of type File or Web
      #
      # The resource content_type should be passed in when it cannot be inferred (e.g. WebResource)
      # for a FileResource this option is optional and will be inferred from the file extension.
      def instance(resource_uri, **opts)
        scheme = resource_uri.scheme.to_sym

        case scheme
        when :file
          create_file_resource(resource_uri, **opts)
        when :http, :https
          create_web_resource(resource_uri, **opts)
        else
          raise 'Unknown schema'
        end
      end

      private

      def create_web_resource(uri, **opts)
        # TODO: Attach Area
        WebResource.new(uri.path, **opts) # state: :alive
      end

      def create_file_resource(uri, **opts)
        opts = opts.merge(file: uri.path)
        # TODO: Attach Area
        FileResource.new(file: uri.path, **opts) # state: :alive
      end
    end
  end
end
