# frozen_string_literal: true

module KManager
  module Cli
    module Commands
      class Version < Dry::CLI::Command
        desc 'Print version'

        def call(*)
          puts KManager::VERSION
        end
      end
    end
  end
end
