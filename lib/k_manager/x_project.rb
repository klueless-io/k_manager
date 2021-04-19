# # frozen_string_literal: true

# module KDsl
#   module Manage
#     # Project all the file paths and DSL documents that are avialable.
#     #
#     # It is assumed there is a root path that DSL's live under,
#     # but you can register from outside this root path using
#     # fully qualified file names.
#     #
#     # Different concepts that relate to register
#     # 1. Registrations is used to pre-register DSL's and generally represents
#     #    the available DSL's that you can interact with.
#     # 2. Import happens after registrationg and represents the instantiation
#     #    of a DSL for use either on it's own or by other DSL's
#     class Project
#       # Project name
#       attr_reader :name

#       # Configuration for this project
#       attr_reader :config

#       # Reference to manager that manages all projects
#       attr_accessor :manager

#       # List of DSL's instances
#       attr_reader :dsls

#       # List of path and wild card patterns to watch for.
#       attr_reader :watch_path_patterns

#       # List of paths containing DSL's
#       #
#       # This list does not keep the wild card pattern.
#       # See: :watch_path_patterns if you need that
#       # 
#       # It does expand the ** for situations where there
#       # is a file in that child path
#       attr_reader :watch_paths

#       # List of resource files that are visible to this project
#       attr_reader :resources

#       # Link resource and document togetner
#       # Resources generally have 1 document, but in the case of
#       # DSL resources there can be more then one document in the resource.
#       # This would then be storing a resource document for each structure
#       # found in the DSL.
#       attr_reader :resource_documents

#       # Listener that is watching for file changes for this project
#       attr_reader :listener

#       # There is currently a tight cupling between is boolean and DSL's so that they know whether they are being refrenced for registration or importation
#       # The difference is that importation will execute their interal code block while registration will not.
#       # attr_reader :current_state
#       # attr_reader :current_register_file

#       # what file is currently being processed
#       # attr_reader :current_processing_file

#       def initialize(name, config = nil, &block)
#         raise KDsl::Error, 'Provide a project name' unless name.is_a?(String) || name.is_a?(Symbol)

#         @name = name
#         @config = config || KDsl::Manage::ProjectConfig.new

#         # REFACT: Wrap DSL's up into it's own class
#         @dsls = {}
#         @watch_path_patterns = []
#         @watch_paths = []
#         @resources = []
#         @resource_documents = []

#         begin
#           instance_eval(&block) if block_given?
#         rescue => exception
#           L.heading "Invalid code block in project during initialization: #{name}"
#           L.exception exception
#           raise
#         end
#       end

#       def add_resource_document(resource, document)
#         resource_document = get_resource_document(document.key, document.type, document.namespace)
#         if resource_document.nil?
#           resource_document = KDsl::ResourceDocuments::ResourceDocument.new(resource, document)
#           resource_documents << resource_document
#         else
#           L.warn "Cannot add to resource_documents for an existing unique_key: #{document.unique_key}"
#         end
#         resource_document
#       end

#       def delete_resource_documents_for_resource(resource)
#         resource_documents.delete_if { |rd| rd.resource == resource }
#       end

#       def resource_document_exist?(key, type = nil, namespace = nil)
#         resource_document = get_resource_document(key, type, namespace)

#         !resource_document.nil?
#       end

#       def get_resource_document(key, type = nil, namespace = nil)
#         unique_key = KDsl::Util.dsl.build_unique_key(key, type, namespace)
#         # L.kv 'uk', unique_key

#         resource_documents.find { |rd| rd.unique_key == unique_key }
#       end

#       # rubocop:disable Metrics/AbcSize
#       def get_resource_documents_by_type(type = nil, namespace = nil)
#         type ||= KDsl.config.default_document_type
#         type = type.to_s
#         namespace = namespace.to_s

#         if namespace.nil? || namespace.empty?
#           resource_documents.select { |resource_document| resource_document.type.to_s == type.to_s }
#         else
#           resource_documents.select { |resource_document| resource_document.namespace == namespace.to_s && resource_document.type.to_s == type.to_s }
#         end
#       end
#       # rubocop:enable Metrics/AbcSize

#       # Register any files found in the absolute path or path relative to base_resource_path
#       #
#       # Files are generally DSL's but support for other types (PORO, Ruby, JSON, CSV) will come
#       def watch_path(path, ignore: nil)
#         @watch_path_patterns << path

#         # puts  "watch path-before: #{path} "
#         path = KDsl::Util.file.expand_path(path, config.base_resource_path)
#         # puts  "watch path-after: #{path} "

#         Dir[path].sort.each do |file|
#           watch_path = File.dirname(file)
#           @watch_paths << watch_path unless @watch_paths.include? watch_path

#           register_file_resource(file, watch_path: watch_path, path_expansion: false, ignore: ignore)
#         end
#       end

#       # Work through each resource and register with document into memory
#       # so that we can access the data in the resource
#       def register_resources
#         @resources.each do |resource|
#           resource.create_documents
#         end
#       end

#       def load_resources
#         # L.progress(nil, 'Load Resource')
#         @resources.each do |resource|
#           # L.progress(nil, 'Debug Resource')
#           # resource.debug
#           # resource.documents.each(&:debug)
#           # L.progress(nil, 'Loading')
#           resource.load
#           # resource.documents.each { |d| d.debug(include_header: true) }
#         end
#       end

#       def get_data(key, type = :entity, namespace = nil)
#         resource_document = get_resource_document(key, type, namespace)

#         raise "Could not get data for missing DSL: #{KDsl::Util.dsl.build_unique_key(key, type, namespace)}" if resource_document.nil?

#         resource_document.document.data
#         # load_data_from_dsl(dsl)
#       end

#       # def load_data_from_dsl(dsl)
#       #   # # Need to load this file
#       #   # if dsl[:state] == :registered
#       #   #   load_file(dsl[:file])
#       #   # end

#       #   dsl[:document].data
#       # end

#       # Register a resource in @registered_resources from a file
#       #
#       # Primary resource that is registered will be a Klue DSL
#       # Other resources that can be supported include
#       # data files:
#       #   CSV, JSON, YAML
#       # ruby code
#       #   Classes etc..
#       def register_file_resource(file, watch_path: nil, path_expansion: true, ignore: nil)
#         file = KDsl::Util.file.expand_path(file, config.base_resource_path) if path_expansion

#         return if ignore && file.match(ignore)
#         return unless File.exist?(file)

#         resource = KDsl::Resources::Resource.instance(
#           project: self,
#           file: file,
#           watch_path: watch_path,
#           source: KDsl::Resources::Resource::SOURCE_FILE)

#         @resources << resource unless @resources.include? resource

#         resource
#       end

#       # # REACT: This method may not belong to project, it should be in it's own class
#       # def process_code(code, source_file = nil)
#       #   guard_source_file(source_file)

#       #   # L.kv 'process_code.file', file
#       #   current_processing_file = source_file

#       #   # print_main_properties
#       #   # L.block code
#       #   begin
#       #     # Anything can potentially run, but generally one of the Klue.factory_methods
#       #     # should run such as Klue.structure or Klue.artifact
#       #     # When they run they can figure out for themselves what file called them by
#       #     # storing @current_processing_file into a document propert
#       #     # rubocop:disable Security/Eval

#       #     # This code is not thread safe
#       #     # SET self as the current project so that we can register within in the document

#       #     eval(code)

#       #     # Clear self as the current project
#       #     # rubocop:enable Security/Eval
#       #   rescue KDsl::Error => e
#       #     puts "__FILE__: #{__FILE__}"
#       #     puts "__LINE__: #{__LINE__}"
#       #     L.error e.message
#       #     raise
#       #   rescue StandardError => e
#       #     L.kv '@current_processing_file', @current_processing_file
#       #     L.kv '@current_state', current_state
#       #     L.kv '@current_register_file', @current_register_file

#       #     L.exception(e)
#       #   end

#       #   @current_processing_file = nil
#       # end

#       def managed?
#         !self.manager.nil?
#       end

#       def watch
#         @listener = Listen.to(*watch_paths) do |modified, added, removed|
#           update_resources(modified) unless modified.empty?
#           add_resources(added) unless added.empty?
#           remove_resources(removed) unless removed.empty?
#           # puts "modified absolute path: #{modified}"
#           # puts "added absolute path: #{added}"
#           # puts "removed absolute path: #{removed}"
#         end
#         @listener.start # not blocking

#         # L.subheading 'Listening'
#         watch_paths.each do |wp|
#           L.kv self.name, wp
#         end

#         @listener
#       end

#       def add_resources(files)
#         files.each do |file|
#           add_resource(file)
#         end
#       end
 
#       def update_resources(files)
#         files.each do |file|
#           update_resource(file)
#         end
#       end

#       def remove_resources(files)
#         files.each do |file|
#           remove_resource(file)
#         end
#       end

#       def add_resource(file)
#         if file.start_with?(template_path)
#           # Resources are ignorable when  in the application .template path
#           # this is reserved for templates only
#           puts "\rSkipping template #{file}\r"
#           return
#         end

#         if File.directory?(file)
#           puts "\rSkipping directory #{file}\r"
#           return
#         end

#         puts "\rAdding #{file}\r"

#         puts @watch_paths

#         watch_path = File.dirname(file)

#         resource = register_file_resource(file, watch_path: watch_path, path_expansion: false, ignore: nil)
#         resource.load_content
#         resource.register
#         resource.load

#         # Unlikely that I want to run a file that is added, if I ever do, thenb
#         # will need to figure out what in the file will trigger this concept
#         # resource.documents.each { |d| d.execute_block(run_actions: true) }

#         2.times { puts '' }
#         debug(formats: [:watch_path_patterns, :resource, :resource_document])
#         # manager.debug(format: :detail, project_formats: [:watch_path_patterns, :resource, :resource_document])
#       end

#       def update_resource(file)
#         puts "\rUpdating #{file}\r"

#         resource = get_resource(file: file)
#         if resource
#           KDsl::Resources::Resource.reset_instance(resource)
#           resource.load_content
#           resource.register
#           resource.load
#           resource.documents.each { |d| d.execute_block(run_actions: true) }

#           # resource.debug

#           2.times { puts '' }
#           debug(formats: [:watch_path_patterns, :resource, :resource_document])
#         else
#           # Resources are ignorable when  in the application .template path
#           # this is reserved for templates only
#           puts 'resource not registered' unless file.start_with?(template_path)
#         end
#       end

#       def remove_resource(file)
#         puts "\rRemoving #{file}\r"

#         @resources.select { |r| r.file == file }
#                   .each { |r| KDsl::Resources::Resource.reset_instance(r) }

#         @resources.delete_if { |r| r.file == file }

#         2.times { puts '' }
#         debug(formats: [:watch_path_patterns, :resource, :resource_document])
#       end

#       def get_resource(file: nil)
#         if file
#           @resources.find { |rd| rd.file == file }
#         end
#       end

#       def debug(format: :resource, formats: [])
#         if formats.present?
#           formats.each { |format| self.debug(format: format) }

#           return
#         end

#         if format == :resource
#           puts ''
#           L.subheading 'List of resources'
#           tp resources.sort_by { |r| [r.source, r.file]},
#           { object_id: {} },
#           :status,
#           { source: { } },
#           { resource_type: { display_name: 'R-Type' } },
#           { content: { width: 100, display_name: 'Content' } },
#           { error: { width: 40, display_method: lambda { |r| r.error && r.error.message ? '** ERROR **' : '' } } },
#           { base_resource_path: { width: 100, display_name: 'Resource Path' } },
#           { relative_watch_path: { width: 100, display_name: 'Watch Path' } },
#           # { :watch_path => { width: 100, display_name: 'Watch Path' } },
#           # { :file => { width: 100, display_name: 'File' } },
#           # { :filename => { width: 100, display_name: 'Filename' } },
#           { filename: { width: 150, display_method: lambda { |r| "\u001b]8;;file://#{r.file}\u0007#{r.filename}\u001b]8;;\u0007" } } }
#         elsif format == :watch_path_patterns
#           puts ''
#           L.subheading 'Watch these paths and patterns'
#           watch_path_patterns.each { |path| L.info path }

#         elsif format == :watch_path
#           puts ''
#           L.subheading 'Watch these paths'
#           watch_paths.each { |path| L.info path }

#         elsif format == :resource_document
#           puts ''
#           L.subheading 'List of documents'
#           tp resource_documents.sort_by { |r| [r.type.to_s, r.namespace.to_s, r.key.to_s]},
#             { object_id: {} },
#             { resource_id: { display_method: lambda { |r| r.resource.object_id } } },
#             { document_id: { display_method: lambda { |r| r.document.object_id } } },
#             :status,
#             { state: { display_method: lambda { |r| r.document.state } } },
#             { namespace: { width: 20, display_name: 'Namespace' } },
#             { key: { width: 30, display_name: 'Key' } },
#             { type: { width: 20, display_name: 'Type' } },
#             # :state,
#             { source: { } },
#             { resource_type: { display_name: 'R-Type' } },
#             { data: { width: 40, display_name: 'Data' } },
#             { error: { width: 40, display_method: lambda { |r| r.error && r.error.message ? '** ERROR **' : '' } } },
#             { base_resource_path: { width: 100, display_name: 'Resource Path' } },
#             { relative_watch_path: { width: 100, display_name: 'Watch Path' } },
#             # { :watch_path => { width: 100, display_name: 'Watch Path' } },
#             # { :file => { width: 100, display_name: 'File' } },
#             # { :filename => { width: 100, display_name: 'Filename' } },
#             { filename: { width: 150, display_method: lambda { |r| "\u001b]8;;file://#{r.file}\u0007#{r.filename}\u001b]8;;\u0007" } } }
#         else
#           # projects.each do |project|
#           #   L.subheading(project.name)
#           #   L.kv 'Base Path', project.config.base_path
#           #   L.kv 'Resource Path', project.config.base_resource_path
#           #   L.kv 'Data_Path', project.config.base_cache_path
#           #   L.kv 'Definition Path', project.config.base_definition_path
#           #   L.kv 'Template Path', project.config.base_template_path
#           #   L.kv 'AppTemplate Path', project.config.base_app_template_path
#           # end
#         end

#       end

#       # TODO: tests
#       def template_path
#         @template_path ||= File.expand_path(config.base_app_template_path)
#       end

#       # def self.create(base_resource_path, base_cache_path: nil, base_definition_path: nil, base_template_path: nil, &block)
#       #   # L.kv 'create1', '@@instance is Present'  if @@instance.present?
#       #   # L.kv 'create1', '@@instance is Nil'      if @@instance.nil?

#       #   if @@instance.nil?
#       #     # L.heading 'in create'
#       #     # L.kv 'dsl', base_resource_path;
#       #     # L.kv 'data', base_cache_path

#       #     @@instance = new(base_resource_path, base_cache_path, base_definition_path, base_template_path)
#       #     @@instance.instance_eval(&block) if block_given?

#       #   end

#       #   @@instance
#       # end

#       # private_class_method :new


#       # def process_code(caller, code, source_file = nil)
#       #   # L.kv 'process_code.caller', caller
#       #   # L.kv 'process_code.source_file', source_file
        
#       #   @current_processing_file = source_file

#       #   if source_file.blank?
#       #     # L.info 'no source files'
#       #   end

#       #   if source_file.present? && !source_file.starts_with?(*@watch_paths)
#       #     L.kv 'source_file', source_file
#       #     raise Klue::Dsl::DslError, 'source file skipped, file is not on a registered path'
#       #   end

#       #   print_main_properties
#       #   # L.block code

#       #   begin
#       #     # Anything can potentially run, but generally one of the Klue.factory_methods 
#       #     # should run such as Klue.structure or Klue.artifact
#       #     # When they run they can figure out for themselves what file called them by 
#       #     # storing @current_processing_file into a document property
#       #     eval(code)
#       #   rescue Klue::Dsl::DslError => exception
#       #     # puts "__FILE__: #{__FILE__}"
#       #     # puts "__LINE__: #{__LINE__}"
#       #     L.error exception.message
#       #     raise

#       #   rescue => exception
#       #     L.kv '@current_processing_file', @current_processing_file
#       #     L.kv '@current_state', current_state
#       #     L.kv '@current_register_file', @current_register_file
    
#       #     L.exception(exception)          
#       #   end
#       #   @current_processing_file = nil
#       # end

#       # def load_file(file, path_expansion: true)
#       #   file = expand_path(file) if path_expansion

#       #   # L.kv 'load_file.file', file

#       #   @current_state = :load_file
#       #   @current_register_file = file

#       #   content = File.read(file)

#       #   process_code(:load_file, content)

#       #   @current_register_file = nil
#       #   @current_state = :dynamic
#       # end

#       # def load_dynamic(content)
#       #   @current_state = :dynamic
#       #   @current_register_file = nil

#       #   process_code(:dynamic, content)

#       #   @current_register_file = nil
#       #   @current_state = :dynamic
#       # end

#       # def save(dsl)
#       #   unique_key = build_unique_key(dsl.k_key, dsl.namespace, dsl.type)
#       #   # L.kv 'action', 'save(dsl)'
#       #   # L.kv '@current_state', current_state
#       #   # L.kv '@unique_key', unique_key

#       #   case @current_state
#       #   when :register_file
#       #     save_register_file(unique_key, dsl.k_key, dsl.namespace, dsl.type)
#       #   when :load_file
#       #     save_load_file(unique_key, dsl.k_key, dsl.namespace, dsl.type, dsl)
#       #   when :dynamic
#       #     save_dynamic(unique_key, dsl.k_key, dsl.namespace, dsl.type, dsl)
#       #   else
#       #     raise 'unknown state'
#       #   end

#       #   dsl
#       # end

#       # def get_relative_folder(fullpath)
#       #   absolute_path = Pathname.new(fullpath)
#       #   project_root  = Pathname.new(base_resource_path)
#       #   relative      = absolute_path.relative_path_from(project_root)
#       #   rel_dir, file = relative.split
        
#       #   rel_dir.to_s
#       # end

#       # def debug(include_header = false)
#       #   if include_header
#       #     L.heading 'Register DSL'
#       #     print_main_properties
#       #     L.line
#       #   end
        
#       #   print_dsls
#       # end

#       # def print_main_properties
#       #   # L.kv 'base_resource_path'       , base_resource_path
#       #   # L.kv 'base_cache_path'          , base_cache_path
#       #   # L.kv 'base_definition_path'     , base_definition_path
#       #   # L.kv 'current_state'            , current_state
#       #   # L.kv 'current_register_file'    , current_register_file
#       #   # L.kv 'current_processing_file'  , current_processing_file
#       # end

#       # def print_dsls
#       #   # tp dsls.values, :k_key, :k_type, :state, :save_at, :last_at, :data, :last_data, :source, { :file => { :width => 150 } }, { :rel_folder => { :width => 80 } }
#       #   tp dsls.values, :namespace, :k_key, :k_type, :state, :save_at, :data, :source, { :file => { :width => 50 } }, { :rel_folder => { :width => 80 } }
#       # end

#       # private

#       def guard_source_file(file)
#         # if file.blank?
#         #   # L.info 'no source files'
#         # end

#         return unless !file.nil? && !file.starts_with?(*@watch_paths)

#         L.kv 'file', file
#         raise KDsl::Error, 'Source file skipped, file is not on a registered path'
#       end

#       # def default_dsl_data(**data)
#       #   { 
#       #     namespace: nil,
#       #     k_key: nil, 
#       #     k_type: nil,
#       #     state: nil, 
#       #     save_at: nil,
#       #     last_at: nil,
#       #     data: nil,
#       #     last_data: nil,
#       #     source: nil, 
#       #     file: nil,
#       #     rel_folder: nil
#       #   }.merge(data)
#       # end

#       # def save_register_file(unique_key, key, type, namespace)
#       #   k = @dsls[unique_key]
    
#       #   if k.present? && k[:file].present? && k[:file] != @current_register_file
#       #     print_dsls

#       #     L.line
#       #     L.kv 'Error', 'Duplicate DSL key found'
#       #     L.kv 'Unique Key', unique_key
#       #     L.kv 'Namespace', namespace
#       #     L.kv 'Key', key
#       #     L.kv 'Type', type
#       #     L.kv 'File', @current_register_file
#       #     L.line
#       #     print
#       #     L.line

#       #     raise Klue::Dsl::DslError, "Duplicate DSL key found #{unique_key} in different files"
#       #   end
    
#       #   if k.present?
#       #     L.line
#       #     L.kv 'Warning', 'DSL already registered'
#       #     L.kv 'Unique Key', unique_key
#       #     L.kv 'Namespace', namespace
#       #     L.kv 'Key', key
#       #     L.kv 'Type', type
#       #     L.kv 'Previous File Name', k[:file]
#       #     L.kv 'Register File Name', @current_register_file
#       #     L.line
#       #     print
#       #     L.line
#       #   else
#       #     @dsls[unique_key] = default_dsl_data(
#       #       namespace: namespace,
#       #       k_key: key, 
#       #       k_type: type, 
#       #       state: :registered,
#       #       source: :file,
#       #       file: @current_register_file,
#       #       rel_folder: get_relative_folder(@current_register_file)
#       #     )
#       #   end
#       # end

#       # def save_load_file(unique_key, key, type, namespace, dsl)
#       #   k = @dsls[unique_key]

#       #   if k.nil?
#       #     # New Record
#       #     @dsls[unique_key] = default_dsl_data(
#       #       namespace: namespace,
#       #       k_key: key, 
#       #       k_type: type, 
#       #       state: :loaded,
#       #       save_at: Time.now.utc,
#       #       data: dsl.get_data(),
#       #       source: :file,
#       #       file: @current_register_file,
#       #       rel_folder: get_relative_folder(@current_register_file)
#       #     )
#       #   else
#       #     # Update Record
#       #     k[:state] = :loaded
#       #     k[:last_at] = k[:save_at]
#       #     k[:save_at] = Time.now.utc
#       #     k[:last_data] = k[:data]
#       #     k[:data] = dsl.get_data()
#       #   end
#       # end

#       # def save_dynamic(unique_key, key, type, namespace, dsl)
#       #   k = @dsls[unique_key]

#       #   if k.nil?
#       #     # New Record
#       #     @dsls[unique_key] = default_dsl_data(
#       #       namespace: namespace,
#       #       k_key: key,
#       #       k_type: type, 
#       #       state: :loaded,
#       #       save_at: Time.now.utc,
#       #       data: dsl.get_data(),
#       #       source: :dynamic
#       #     )
#       #   else
#       #     # Update Record
#       #     k[:state] = :loaded
#       #     k[:last_at] = k[:save_at]
#       #     k[:save_at] = Time.now.utc
#       #     k[:last_data] = k[:data]
#       #     k[:data] = dsl.get_data()
#       #   end
#       # end

#       # This makes more sense at an APP level, instead of a project level
#       # def self.reset
#       #   @@instance = nil
#       # end

#       # def self.get_instance
#       #   # Note: if you have already created an instance using custom code then it will re-used
#       #   @@instance
#       # end
#     end
#   end
# end
