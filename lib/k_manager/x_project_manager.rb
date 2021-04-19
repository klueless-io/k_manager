# # frozen_string_literal: true

# # Provide access to the DSL Manager
# module KDsl
#   module Manage
#     # Manager is used to manage active projects and memory management
#     class ProjectManager
#       attr_accessor :projects
#       attr_accessor :active_project

#       def initialize
#         @projects = []
#         @active_project = nil
#       end

#       def add_project(project)
#         raise KDsl::Error, 'Project is required' if project.nil?
#         raise KDsl::Error, 'Project class is ivalid' unless project.is_a?(KDsl::Manage::Project)

#         project.manager = self
#         # project.register_resources

#         @projects |= [project]
#       end

#       def add_projects(*projects)
#         projects.each { |project| self.add_project(project) }
#       end

#       def register_all_resource_documents
#         projects.each(&:register_resources)
#       end

#       def load_all_documents
#         projects.each(&:load_resources)
#       end

#       def activate_project(project)
#         add_project(project)

#         @active_project = project
#       end

#       def deactivate_project
#         @active_project = nil
#       end

#       def watch
#         L.block "Project manager is watching resources for #{'project'.pluralize(projects.length)}"

#         projects.each do |project|
#           project.watch
#         end

#         wait_key

#         L.block 'Stopping'

#         projects.each do |project|
#           project.listener.stop
#         end

#         L.block 'Stopping'

#       end
      
#       # require 'io/console'
#       def wait_key
#         sleep
#         # print "press any key to stop\r"
#         # STDIN.getch
#         # print "xxxxxxxxxxxx\r" # extra space to overwrite in case next sentence is short
#       end                                                                                                                        

#       # Register document with a project
#       #
#       # There is a tight coupling between new document instances and the active project
#       # If I can find a way to decouple then I will, but for now, a new document will
#       # call through to register_with_project and if there is no project then it will just
#       # keep going
#       # def register_with_project(document)
#       #   return :no_project if active_project.nil?

#       #   # return :register
#       #   # return :existing
#       # end

#       def debug(format: :tabular, project_formats: [:resource])
#         # tp projects

#         case format
#         when :tabular
#           tp projects,
#             :name,
#             :managed?,
#             { 'config.base_path'              => { width: 60, display_name: 'Base Path' } },
#             { 'config.base_resource_path'     => { width: 60, display_name: 'Resource Path' } },
#             { 'config.base_cache_path'        => { width: 60, display_name: 'Cache Path' } },
#             { 'config.base_definition_path'   => { width: 60, display_name: 'Definition Path' } },
#             { 'config.base_template_path'     => { width: 60, display_name: 'Template Path' } },
#             { 'config.base_app_template_path' => { width: 60, display_name: 'AppTemplate Path' } }
#         when :simple
#           projects.each do |project|
#             L.subheading("Project #{project.name}")
#             project_formats.each do |project_format|
#               project.debug(format: project_format)
#             end
#           end
#         when :detail
#           L.kv '# of Projects', projects.length

#           projects.each do |project|
#             L.subheading("Project #{project.name}")
#             L.kv "Resource Path (DSL's, Data)", project.config.base_resource_path
#             L.kv 'Base Path', project.config.base_path
#             L.kv 'Cache Data Path', project.config.base_cache_path
#             L.kv 'Definition Path', project.config.base_definition_path
#             L.kv 'Template Path (Global)', project.config.base_template_path
#             L.kv 'Template Path (Application)', project.config.base_app_template_path
#             puts

#             project.debug(formats: project_formats)
#             # project_formats.each do |project_format|
#             #   project.debug(format: project_format)
#             # end
#           end
#         end

#       end
#     end
#   end
# end
