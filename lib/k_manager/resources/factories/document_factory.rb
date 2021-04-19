# # frozen_string_literal: true
# require 'csv'

# module KDsl
#   module Resources
#     module Factories
#       # Base factory for creationg resource_documents
#       # Tightly coupled to the resource using polymorphic composition
#       # Something WRONG, should this be a module include instead of a Forwardable Class?
#       class DocumentFactory
#         extend Forwardable

#         attr_reader :resource

#         def_delegator :resource, :project
#         def_delegator :resource, :content
#         def_delegator :resource, :documents
#         def_delegator :resource, :new_document
#         def_delegator :resource, :add_document
#         def_delegator :resource, :infer_document_key
#         def_delegator :resource, :infer_document_type
#         def_delegator :resource, :infer_document_namespace

#         def initialize(resource, resource_type)
#           @resource = resource
#           resource.resource_type = resource_type
#         end

#         def self.instance(resource, source, file)
#           if source === KDsl::Resources::Resource::SOURCE_FILE
#             extension = File.extname(file).downcase

#             case extension
#             when '.rb'
#               return KDsl::Resources::Factories::RubyDocumentFactory.new(resource)
#             when '.csv'
#               return KDsl::Resources::Factories::CsvDocumentFactory.new(resource)
#             when '.json'
#               return KDsl::Resources::Factories::JsonDocumentFactory.new(resource)
#             when '.yaml'
#               return KDsl::Resources::Factories::YamlDocumentFactory.new(resource)
#             end
#           end

#           return KDsl::Resources::Factories::UnknownDocumentFactory.new(resource)
#         end

#       end
#     end
#   end
# end
