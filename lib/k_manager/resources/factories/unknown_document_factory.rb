# frozen_string_literal: true
# # frozen_string_literal: true
# require 'csv'

# module KDsl
#   module Resources
#     module Factories
#       # UnknownContentProcessor can handle Unknown content and produce a document
#       class UnknownDocumentFactory < DocumentFactory
#         def initialize(resource)
#           super(resource, KDsl::Resources::Resource::TYPE_UNKNOWN)
#         end

#         def create_documents
#           @document = add_document(new_document)
#         end

#         def parse_content
#           @document.set_data({})
#         end

#         def debug
#           L.warn 'unknown document'
#         end
#       end
#     end
#   end
# end
