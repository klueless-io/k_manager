# frozen_string_literal: true
# # frozen_string_literal: true
# require 'csv'

# module KDsl
#   module Resources
#     module Factories
#       # CsvDocumentFactory can handle CSV content to produce a document
#       class CsvDocumentFactory < DocumentFactory
#         def initialize(resource)
#           super(resource, KDsl::Resources::Resource::TYPE_CSV)
#         end

#         def create_documents
#           @document = add_document(new_document)
#         end

#         def parse_content
#           data = []
#           CSV.parse(content, headers: true, header_converters: :symbol).each do |row|
#             data << row.to_h
#           end
#           @document.set_data(data)
#         end

#         def debug
#           tp @document.data, @document.data.first.to_h.keys
#         end
#       end
#     end
#   end
# end
