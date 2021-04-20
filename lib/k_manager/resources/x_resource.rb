# frozen_string_literal: true

# module KDsl
#   module Resources
#     # Resource represents a file in the project
#     #
#     # Resources currently represent DSL's but I think I can have support for
#     # other types of files such as (PORO, Ruby, JSON, CSV) and be able to use
#     # them easily.
#     class Resource
#       # Resources must belong to a factory
#       attr_reader :project

#       # Status of the resource
#       # - :initialized
#       # - :content_loading
#       # - :content_loaded
#       # - :registering
#       # - :registered
#       # - :loading
#       # - :loaded
#       attr_reader :status

#       # Resources create documents via a resource specific factory
#       attr_accessor :document_factory

#       # Store an exeption that may exist
#       # REFACT: This should move to ResourceDocument
#       attr_accessor :error

#       # Currently supports read from file, but will support read from HTTP in the future
#       SOURCE_FILE = 'file'

#       # Not implement
#       # SOURCE_URI = 'uri'
#       # SOURCE_DYNAMIC = 'dynamic'

#       TYPE_UNKNOWN = 'unknown'
#       TYPE_CSV = 'csv'
#       TYPE_JSON = 'json'
#       TYPE_RUBY = 'ruby'
#       TYPE_RUBY_DSL = 'dsl'
#       TYPE_YAML = 'yaml'

#       # Source of the content
#       #
#       # :file, :uri, :dynamic
#       attr_reader :source

#       # Type of resource, infered via the document factory type
#       attr_accessor :resource_type

#       # Full file path
#       #
#       # example: /Users/davidcruwys/dev/kgems/k_dsl/spec/factories/dsls/common-auth/admin_user.rb
#       attr_reader :file

#       # If the file is watched, what was it's base watch path
#       #
#       # Currently only used for informational/debugging purpose
#       #
#       # example: /Users/davidcruwys/dev/kgems/k_dsl/spec/factories/dsls/common-auth
#       attr_reader :watch_path

#       # Content of resource, use read content to load this property
#       attr_reader :content

#       # List of documents derived from this resource
#       #
#       # Most resources will create on document, but a DSL can generate multiple
#       # documents and some future resources may do as well
#       # Currently there will always be a minimum of 1 document even if the resource
#       # is not a data resource, e.g. Ruby class
#       attr_accessor :documents

#       def initialize(project: nil, source: nil, file: nil, watch_path: nil)
#         @status = :initialized
#         @project = project
#         @source = source
#         @file = file
#         @watch_path = watch_path
#         @documents = []
#       end

#       def self.instance(project:, source: KDsl::Resources::Resource::SOURCE_FILE, file: nil, watch_path: nil)
#         raise ::KDsl::Error, 'Unknown source' unless [SOURCE_FILE].include? source

#         resource = Resource.new(
#           project: project,
#           source: source,
#           file: file,
#           watch_path: watch_path
#         )

#         resource.document_factory = KDsl::Resources::Factories::DocumentFactory.instance(resource, source, file)
#         resource
#       end

#       def self.reset_instance(resource)
#         resource.project.delete_resource_documents_for_resource(resource)
#         resource.documents = []
#       end

#       def create_documents
#         KDsl.target_resource = self

#         load_content
#         register

#         KDsl.target_resource = nil
#       end

#       def load_content
#         @status = :content_loading
#         @content = nil
#         if source === SOURCE_FILE
#           L.kv 'SOURCE_FILE', SOURCE_FILE
#           if File.exist?(file)
#             begin
#               @content = File.read(file)
#             rescue StandardError => e
#               L.error e
#             end
#           else
#             @error = KDsl::Error.new("Source file not found: #{file}")
#           end
#         end
#         @status = :content_loaded
#       end

#       def register
#         @status = :registering
#         document_factory.create_documents
#         @status = :registered
#       end

#       def load
#         @status = :loading
#         document_factory.parse_content
#         @status = :loaded
#       end

#       def exist?
#         source === SOURCE_FILE && File.exist?(file)
#       end

#       def new_document(klass: KDsl::Model::Document, key: infer_document_key, type: infer_document_type, namespace: infer_document_namespace)
#         klass.new(key, type, namespace: namespace)
#       end

#       # TEST REQUIRED
#       def add_documents(*documents)
#         documents.each do |document|
#           add_document(document)
#         end
#       end

#       # TEST REQUIRED
#       def add_document(document)
#         # project.register_dsl(document)
#         project.add_resource_document(self, document)
#         document.resource = self
#         documents << document
#         document
#       end

#       # example:  ~/dev/kgems/k_dsl/spec/factories/dsls
#       def relative_watch_path
#         @relative_watch_path ||= watch_path&.delete_prefix(base_resource_path_expanded)
#       end

#       # example:  ~/dev/kgems/k_dsl/spec/factories/dsls
#       def filename
#         @filename ||= File.basename(file)
#       end

#       # example:  ~/dev/kgems/k_dsl/spec/factories/dsls
#       def base_resource_path
#         project.config.base_resource_path
#       end

#       # example:  /Users/david/dev/kgems/k_dsl/spec/factories/dsls
#       def base_resource_path_expanded
#         @base_resource_path ||= File.expand_path(project.config.base_resource_path)
#       end

#       def infer_document_key
#         if filename
#           File.basename(filename, File.extname(filename))
#         else
#           'unknown'
#         end
#       end

#       def infer_document_namespace
#         ''
#       end

#       def infer_document_type
#         if filename
#           ext = File.extname(filename)
#           case ext
#           when '.json', '.csv', '.yaml'
#             ext.delete('.')
#           when '.rb'
#             'ruby'
#           else
#             'unknown'
#           end
#         else
#           'unknown'
#         end
#       end

#       def debug(*formats)
#         formats = %i[resource] if formats.empty?

#         formats.each do |format|
#           case format
#           when :resource
#             L.kv 'project.name', project.name
#             L.kv 'document_factory.class', document_factory.class.name
#             L.kv 'status', status
#             L.kv 'error', error&.message
#             L.kv 'source', source
#             L.kv 'resource_type', resource_type
#             L.kv 'file', file
#             L.kv 'watch_path', watch_path
#             # L.kv 'content', content
#             L.kv 'document.count', documents.length
#           when :document
#             documents.each do |document|
#               document.debug(true)
#             end
#           when :document_data
#             # Data Only
#             documents.each(&:debug)
#           end
#         end
#       end
#     end
#   end
# end
