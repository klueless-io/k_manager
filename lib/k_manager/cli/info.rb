# frozen_string_literal: true

module KManager
  module Cli
    module Commands
      class Info < KManager::Cli::Commands::BaseCommand
        desc      'Print information about builder, project, and watcher folders'

        argument  :project_folder,
                  default: '.',
                  desc: 'Info project folder (defaults to current directory .)'

        option    :builder_folder,
                  default: '.builders',
                  desc: 'The builder folder, defaults to (.builders)'

        def call(project_folder:, builder_folder:, **)
          project_folder  = absolute_path(project_folder, Dir.pwd)
          # name must be after project_folder
          name            = File.basename(project_folder)
          builder_folder  = absolute_path(builder_folder, project_folder)

          log_params(name, project_folder, builder_folder)
        end

        private

        def log_params(name, project_folder, builder_folder)
          log.section_heading('Information')
          log.kv 'Project Name'         , name
          log.kv 'Project Folder'       , project_folder
          log.kv 'Builder Folder'       , builder_folder
          log.kv 'Project File Count'   , project_file_count(project_folder, builder_folder)
          log.kv 'Builder File Count'   , builder_file_count(builder_folder)

          # log_files(project_folder, project_file_list(project_folder, builder_folder), 'Project Files List')
          log_files(builder_folder, builder_file_list(builder_folder), 'Builder Files')
        end

        def log_files(root_folder, files, title)
          log.section_heading(title)
          files.each do |file|
            pathname = Pathname.new(file)
            puts pathname.relative_path_from(root_folder).to_s
          end
        end

        def project_file_count(project_folder, builder_folder)
          project_file_list(project_folder, builder_folder).length
        end

        def project_file_list(project_folder, builder_folder)
          return @project_file_list if defined? @project_file_list

          @project_file_list = begin
            pattern = '{.[^\.]*,*,**}/**/*'

            result = Dir.chdir(project_folder) do
              Dir.glob(pattern).map { |f| File.realpath(f) }
            end

            result - builder_file_list(builder_folder)
          end
        end

        def builder_file_count(builder_folder)
          builder_file_list(builder_folder).length
        end

        # Dir.glob(".").map(&File.method(:realpath))
        def builder_file_list(builder_folder)
          return @builder_file_list if defined? @builder_file_list

          @builder_file_list = Dir.chdir(builder_folder) do
            Dir.glob('**/*').map { |f| File.realpath(f) }
          end
        end
      end
    end
  end
end
