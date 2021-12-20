# frozen_string_literal: true

module KManager
  module Cli
    module Commands
      class New < KManager::Cli::Commands::BaseCommand
        desc      'Create a new KManager project'

        argument  :project_folder,
                  default: '.',
                  desc: 'New project folder (defaults to current directory .)'

        option    :builder_folder,
                  default: '.builders',
                  desc: 'The builder folder, defaults to (.builders)'

        option    :boot_file,
                  default: 'boot.rb',
                  aliases: ['-b'],
                  desc: 'The name of the boot file to create'

        option    :force,
                  default: false,
                  aliases: ['-f'],
                  desc: 'Force even if guard fails'

        example [
          '                           # Project in current directory - will create a .builders folder and boot file at ./builders/boot.rb',
          '-b ../config/boot.rb       # Project in current directory - will create a .builders folder and boot file at ./config/boot.rb',
          'my_project                 # will watch .xmen folder'
        ]

        def call(project_folder:, builder_folder:, boot_file:, log_level:, force:, **)
          project_folder  = absolute_path(project_folder, Dir.pwd)
          name            = File.basename(project_folder)
          builder_folder  = absolute_path(builder_folder, project_folder)
          boot_file       = absolute_path(boot_file, builder_folder)

          log_params(name, project_folder, builder_folder, boot_file, force) if log_level == 'debug'

          create_project(project_folder, builder_folder, boot_file) if can_create?(force, builder_folder)
        end

        private

        def create_project(project_folder, builder_folder, boot_file)
          FileUtils.mkdir_p(project_folder)
          FileUtils.mkdir_p(builder_folder)
          File.write(boot_file, '# Boot Sequence')
          # Use a boot_file_template if needed

          log.info 'Project created'
        end

        def can_create?(force, builder_folder)
          return true if force
          return true unless File.directory?(builder_folder)

          log.error "Project builder folder already exists: #{builder_folder}"

          false
        end

        def log_params(name, project_folder, builder_folder, boot_file, force)
          log.section_heading('Create new project')
          log.kv 'name'           , name
          log.kv 'project_folder' , project_folder
          log.kv 'builder_folder' , builder_folder
          log.kv 'boot_file'      , boot_file
          log.kv 'force'          , force
        end
      end
    end
  end
end
