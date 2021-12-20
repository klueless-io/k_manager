# frozen_string_literal: true

module KManager
  module Cli
    module Commands
      class BaseCommand < Dry::CLI::Command
        include KLog::Logging

        option    :log_level,
                  default: 'none',
                  aliases: ['-l'],
                  desc: 'Log level (:none, :debug)'

        private

        def absolute_path(path, base_path)
          pathname = Pathname.new(path)
          pathname.absolute? ? path : File.expand_path(path, base_path)
        end
      end
    end
  end
end
