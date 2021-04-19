# # frozen_string_literal: true
# require 'csv'

# module KDsl
#   module Resources
#     module Factories
#       # YamlDocumentFactory can handle YAML content to produce a document
#       class YamlDocumentFactory < DocumentFactory
#         def initialize(resource)
#           super(resource, KDsl::Resources::Resource::TYPE_YAML)
#         end

#         def create_documents
#           @document = add_document(new_document)
#         end

#         def parse_content
#           data = YAML.load(content)
#           @document.set_data(data)
#         end

#         def debug
#           L.ostruct(KDsl::Util.data.to_struct(@document.data))
#         end
#       end
#     end
#   end
# end
