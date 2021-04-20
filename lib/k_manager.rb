# frozen_string_literal: true

require 'k_builder'
require 'k_ext/github'
require 'k_log'

require 'k_manager/version'
require 'k_manager/configuration/project_config'
require 'k_manager/resources/base_resource'
require 'k_manager/resources/file_resource'
require 'k_manager/resources/csv_file_resource'
require 'k_manager/resources/json_file_resource'
require 'k_manager/resources/ruby_file_resource'
require 'k_manager/resources/yaml_file_resource'
require 'k_manager/resources/unknown_file_resource'
require 'k_manager/project'

module KManager
  # raise KManager::Error, 'Sample message'
  class Error < StandardError; end

  class << self
    def new_project_config(&block)
      config = KManager::Configuration::ProjectConfig.new
      block.call(config) if block_given?
      config
    end

    # def configuration
    #   @configuration ||= KManager::Configuration.new
    # end

    # def reset_configuration
    #   @configuration = KManager::Configuration.new
    # end

    # def configure
    #   yield(configuration)
    # end
  end
end

if ENV['KLUE_DEBUG']&.to_s&.downcase == 'true'
  namespace = 'KManager::Version'
  file_path = $LOADED_FEATURES.find { |f| f.include?('k_manager/version') }
  version = KManager::VERSION.ljust(9)
  puts "#{namespace.ljust(35)} : #{version.ljust(9)} : #{file_path}"
end
