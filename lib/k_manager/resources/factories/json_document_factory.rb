# frozen_string_literal: true
# # frozen_string_literal: true
# require 'csv'

# module KDsl
#   module Resources
#     module Factories
#       # JsonDocumentFactory can handle JSON content to produce a document
#       class JsonDocumentFactory < DocumentFactory
#         def initialize(resource)
#           super(resource, KDsl::Resources::Resource::TYPE_JSON)
#         end

#         def create_documents
#           @document = add_document(new_document)
#         end

#         def parse_content
#           data = JSON.parse(content)
#           @document.set_data(data)
#         end

#         def debug
#           L.ostruct(KDsl::Util.data.to_struct(@document.data))
#         end
#       end
#     end
#   end
# end
