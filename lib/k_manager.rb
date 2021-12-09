# frozen_string_literal: true

require 'csv'
require 'dry-struct'
require 'forwardable'
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
  class Error < StandardError; end # raise KManager::Error, 'Sample message'

  class << self
    extend Forwardable
    
    # ----------------------------------------------------------------------
    # Concurrency management for currently focused resource
    # ----------------------------------------------------------------------

    attr_reader :current_resource

    def resource_mutex
      @resource_mutex ||= Mutex.new
    end

    def for_resource(resource = nil)
      resource_mutex.synchronize do
        @current_resource = resource
        yield(current_resource)
        @current_resource = nil
      end
    end

    def for_current_resource
      raise KManager::Error, 'Attempting to yield current_resource, when a different thread has the lock?' unless resource_mutex.owned?

      yield(@current_resource)
    end

    # ----------------------------------------------------------------------
    # Manager facade methods
    # ----------------------------------------------------------------------

    def manager
      @manager ||= Manager.new
    end

    def_delegators :manager, :areas, :add_area, :fire_actions

    # ----------------------------------------------------------------------
    # Document factory facade methods
    # ----------------------------------------------------------------------

    def document_factory
      @document_factory ||= DocumentFactory.new
    end

    def_delegators :document_factory, :model, :csv, :json, :yaml

    # TODO: DEPRECATE or REFACTOR
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
