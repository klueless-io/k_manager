# frozen_string_literal: true

require 'dry/cli'
require_relative 'base_command'
require_relative 'version'
require_relative 'watch'
require_relative 'new'
require_relative 'info'

module KManager
  module Cli
    module Commands
      extend Dry::CLI::Registry

      register 'version'    , Version     , aliases: %w[v -v --version]
      register 'watch'      , Watch       , aliases: %w[w]
      register 'new'        , New         , aliases: %w[n]
      register 'info'       , Info        , aliases: %w[i]

      # register 'generate', aliases: ['g'] do |prefix|
      #   prefix.register 'config', Generate::Configuration
      # end
    end
  end
end
