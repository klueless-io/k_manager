# frozen_string_literal: true

module KManager
  module Cli
    module Commands
      class Watch < KManager::Cli::Commands::BaseCommand
        desc      'Watch folder'

        argument  :builder_folder,
                  default: '.builders',
                  desc: 'Folder to watch (aka builder folder), defaults to (.builders)'

        option    :boot_file,
                  default: 'boot.rb',
                  aliases: ['-b'],
                  desc: 'The boot file used for k_manager configuration'

        example [
          '                           # will watch .builders folder and boot from ./builders/boot.rb',
          '-b ../config/boot.rb       # will watch .builders folder and boot from ./config/boot.rb',
          '.xmen                      # will watch .xmen folder'
        ]

        def call(builder_folder:, boot_file:, log_level: , **)
          builder_folder = absolute_path(builder_folder, Dir.pwd)
          boot_file = absolute_path(boot_file, builder_folder)

          log_params(builder_folder, boot_file) if log_level == 'debug'

          # If you do a System Exit (control+c) you can go into a reboot sequence based on options
          # if the option is not set then system will exit gracefully
          while keep_watching(builder_folder, boot_file); end
        end

        private

        # rubocop:disable Metrics/AbcSize
        def keep_watching(builder_folder, boot_file)
          Dir.chdir(builder_folder) do
            watcher = KManager::Watcher.new(builder_folder, boot_file)
            watcher.start
          end
          false
        rescue Interrupt, SystemExit
          if KManager.opts.reboot_on_kill == true || KManager.opts.reboot_on_kill == 1
            puts "\nRebooting #{KManager.opts.app_name}..."
            sleep KManager.opts.reboot_sleep unless KManager.opts.reboot_sleep.zero?

            return true
          end

          puts "\nExiting..."
          false
        end
        # rubocop:enable Metrics/AbcSize

        def log_params(builder_folder, boot_file)
          log.section_heading('Watch project')
          log.kv 'builder_folder' , builder_folder
          log.kv 'boot_file' , boot_file
        end
      end
    end
  end
end
