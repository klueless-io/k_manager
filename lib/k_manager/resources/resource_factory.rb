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
          FileResource.new(resource_uri, **opts)
        when :http, :https
          WebResource.new(resource_uri, **opts)
        else
          raise 'Unknown schema'
        end
      end
    end
  end
end
