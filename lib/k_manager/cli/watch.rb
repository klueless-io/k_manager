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

          # puts builder_folder
          # puts boot_file

          Dir.chdir(builder_folder) do
            watcher = KManager::Watcher.new(builder_folder, boot_file)
            watcher.start
          end
        end

        private

        def log_params(builder_folder, boot_file)
          log.section_heading('Watch project')
          log.kv 'builder_folder' , builder_folder
          log.kv 'boot_file' , boot_file
        end
      end
    end
  end
end
