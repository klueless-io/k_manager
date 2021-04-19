# # frozen_string_literal: true

# module KDsl
#   module ResourceDocuments
#     # ResourceDocument represents the (1-M) link between a resource and a document
#     class ResourceDocument
#       extend Forwardable

#       attr_reader :resource
#       attr_reader :document

#       def_delegator :resource, :status
#       def_delegator :resource, :project
#       def_delegator :resource, :source
#       def_delegator :resource, :resource_type
#       def_delegator :resource, :file
#       def_delegator :resource, :watch_path
#       def_delegator :resource, :content
#       def_delegator :resource, :relative_watch_path
#       def_delegator :resource, :filename
#       def_delegator :resource, :base_resource_path
#       def_delegator :resource, :base_resource_path_expanded

#       # I HAVE an issue between resource.error and document.error that needs to be dealt with
#       def_delegator :document, :error
#       def_delegator :document, :unique_key
#       def_delegator :document, :key
#       def_delegator :document, :type
#       def_delegator :document, :namespace
#       def_delegator :document, :options
#       def_delegator :document, :executed?
#       def_delegator :document, :initialized?

#       def_delegator :document, :data

#       def initialize(resource, document)
#         @resource = resource
#         @document = document
#       end

#       def debug(format: :detail)
#         L.line
#         L.kv 'Status', status
#         resource.debug
#         document.debug(include_header: true)
#       end

#     end
#   end
# end
