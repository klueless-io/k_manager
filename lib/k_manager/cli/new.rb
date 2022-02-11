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

        option    :force,
                  default: false,
                  aliases: ['-f'],
                  desc: 'Force even if guard fails'

        option    :template,
                  default: false,
                  aliases: ['-t'],
                  desc: 'Starter template'

        option    :log_level,
                  default: nil,
                  desc: 'Log level, use debug for more info'

        option    :description,
                  default: nil,
                  aliases: ['-d'],
                  desc: 'Application description'

        option    :user_story,
                  default: nil,
                  desc: 'Main user story'

        option    :repo_organization,
                  default: nil,
                  desc: 'Repository organization'

        example [
          '                           # Project in current directory - will create a .builders folder and boot file at ./builders/boot.rb',
          '-b ../config/boot.rb       # Project in current directory - will create a .builders folder and boot file at ./config/boot.rb',
          '-t ruby_gem                # Use starter template `ruby_gem` to setup the files in .builders/*',
          'my_project                 # will watch .xmen folder'
        ]

        # rubocop:disable Metrics/ParameterLists
        def call(project_folder:, builder_folder:, log_level:, force:, template:, **opts)
          project_folder        = absolute_path(project_folder, Dir.pwd)
          name                  = File.basename(project_folder)
          builder_folder        = absolute_path(builder_folder, project_folder)
          template_root_folder  = File.expand_path('~/dev/kgems/k_templates/definitions/starter')

          log_params(name, project_folder, builder_folder, force, log_level, template_root_folder, template, **opts) if log_level == 'debug'

          create_project(name, project_folder, builder_folder, template_root_folder, template, **opts) if can_create?(force, builder_folder)
        end
        # rubocop:enable Metrics/ParameterLists

        private

        # rubocop:disable Metrics/ParameterLists
        def create_project(name, project_folder, builder_folder, template_root_folder, template, **opts)
          FileUtils.mkdir_p(project_folder)
          FileUtils.mkdir_p(builder_folder)

          # handle_main_start_command

          setup_builder_from_template(name, builder_folder, template_root_folder, 'default', **opts) unless setup_builder_from_template(name, builder_folder, template_root_folder, template, **opts)

          log.info 'Project created'
        end
        # rubocop:enable Metrics/ParameterLists

        def setup_builder_from_template(name, builder_folder, template_root_folder, template, **opts)
          return false unless template

          # /Users/davidcruwys/dev/kgems/k_templates/definitions/starter/ruby_gem/.starter.json
          template_folder = File.join(template_root_folder, template)
          starter_config = template_starter_config(template_folder)

          return false unless starter_config

          builder = get_builder(builder_folder, template_folder)

          return false if starter_config['files'].nil? || starter_config['files'].empty?

          starter_config['files']&.each do |relative_file|
            builder.add_file(relative_file, template_file: relative_file, **{ name: name }.merge(opts))
          end
        end

        def template_starter_config(template_folder)
          starter_file = File.join(template_folder, '.starter.json')

          return nil unless File.exist?(starter_file)

          JSON.parse(File.read(starter_file))
        end

        # rubocop:disable Metrics/AbcSize
        def get_builder(builder_folder, template_folder)
          Handlebars::Helpers.configure do |config|
            config.helper_config_file = File.join(Gem.loaded_specs['handlebars-helpers'].full_gem_path, '.handlebars_helpers.json')
            config.string_formatter_config_file = File.join(Gem.loaded_specs['handlebars-helpers'].full_gem_path, '.handlebars_string_formatters.json')
          end

          KConfig.configure(:starter_template) do |config|
            config.target_folders.add(:builder              , builder_folder)
            config.template_folders.add(:template           , template_folder)
          end

          KBuilder::BaseBuilder.init(KConfig.configuration(:starter_template))
        end
        # rubocop:enable Metrics/AbcSize

        def can_create?(force, builder_folder)
          return true if force
          return true unless File.directory?(builder_folder)

          log.error "Project builder folder already exists: #{builder_folder}"

          false
        end

        # rubocop:disable Metrics/ParameterLists, Metrics/AbcSize
        def log_params(name, project_folder, builder_folder, force, log_level, template_root_folder, template, **opts)
          log.section_heading('Create new project')
          log.kv 'name'                 , name
          log.kv 'project_folder'       , project_folder
          log.kv 'builder_folder'       , builder_folder
          log.kv 'force'                , force
          log.kv 'log_level'            , log_level
          log.kv 'template_root_folder' , template_root_folder
          log.kv 'template'             , template

          opts.each do |key, value|
            log.kv key, value
          end
        end
        # rubocop:enable Metrics/ParameterLists, Metrics/AbcSize
      end
    end
  end
end
