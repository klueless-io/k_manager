# frozen_string_literal: true

require 'csv'
require 'dry-struct'
require 'k_log'
require 'k_doc'
require 'k_fileset'
require 'k_builder'
require 'k_ext/github'

# IS THIS NEEDED? this was used for infer_key
require 'handlebars/helpers/string_formatting/dasherize'
require 'handlebars/helpers/string_formatting/snake'

require 'k_manager/version'
require 'k_manager/configuration/project_config'
require 'k_manager/overview/models'
require 'k_manager/overview/queries'
require 'k_manager/overview/dump_json'
require 'k_manager/overview/dashboard'
require 'k_manager/resources/resource_set'
require 'k_manager/resources/base_resource'
require 'k_manager/resources/file_resource'
require 'k_manager/resources/web_resource'
require 'k_manager/resources/mem_resource'
require 'k_manager/resources/resource_document_factory'
require 'k_manager/resources/resource_factory'
require 'k_manager/resources/resource_manager'
require 'k_manager/document_factory'
require 'k_manager/manager'
require 'k_manager/area'

module KManager
  extend Manager
  extend DocumentFactory

  # raise KManager::Error, 'Sample message'
  class Error < StandardError; end

  class << self
    def new_project_config(&block)
      config = KManager::Configuration::ProjectConfig.new
      block.call(config) if block_given?
      config
    end
  end
end

if ENV['KLUE_DEBUG']&.to_s&.downcase == 'true'
  namespace = 'KManager::Version'
  file_path = $LOADED_FEATURES.find { |f| f.include?('k_manager/version') }
  version = KManager::VERSION.ljust(9)
  puts "#{namespace.ljust(35)} : #{version.ljust(9)} : #{file_path}"
end
