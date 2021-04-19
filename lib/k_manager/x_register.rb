# # frozen_string_literal: true

# module KDsl
#   module Manage
#     class Register
#       # private_class_method :new
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

#       # def is_pathname_absolute(pathname)
#       #   Pathname.new(pathname).absolute?
#       # end

#       # def expand_path(filename)
#       #   if is_pathname_absolute(filename)
#       #     filename
#       #   elsif filename.start_with?('~/')
#       #     File.expand_path(filename)
#       #   else
#       #     File.expand_path(filename, base_resource_path)
#       #   end
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
#       #   # L.kv 'base_resource_path'            , base_resource_path
#       #   # L.kv 'base_cache_path'           , base_cache_path
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
#     end
#   end
# end
