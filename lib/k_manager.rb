# frozen_string_literal: true

require 'csv'
require 'dry-struct'
require 'forwardable'
require 'k_log'
require 'k_config'
require 'cmdlet'
require 'k_doc'
require 'k_domain'
require 'k_director'
require 'k_fileset'
require 'k_builder'
require 'k_ext/github'
require 'drawio_dsl'
require 'tailwind_dsl'

require 'k_manager/version'
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
require 'k_manager/watcher'

module KManager
  # raise KManager::Error, 'Sample message'
  class Error < StandardError; end

  class << self
    extend Forwardable

    # ----------------------------------------------------------------------
    # Concurrency management for currently focused resource
    # ----------------------------------------------------------------------

    # NOTE: Can mutex be moved into manager?
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
    # Debug Flags
    # ----------------------------------------------------------------------

    def debug_state
      return @debug_state if defined? @debug_state

      @debug_state = :disabled
    end

    def debug_enable
      @debug_state = :enabled
    end

    def debug?
      debug_state == :enabled
    end

    # ----------------------------------------------------------------------
    # Manager facade methods
    # ----------------------------------------------------------------------

    def manager
      @manager ||= Manager.new
    end

    def reset
      # @resource_mutex.unlock if @resource_mutex
      # @current_resource = nil
      @manager = Manager.new
    end

    def_delegators  :manager,
                    :opts,
                    :areas,
                    :area_resources,
                    :area_documents,
                    :add_area,
                    :find_document,
                    :fire_actions,
                    :resource_changed,
                    :boot,
                    :reboot,
                    :debug

    # ----------------------------------------------------------------------
    # Document factory facade methods
    # ----------------------------------------------------------------------

    def document_factory
      @document_factory ||= DocumentFactory.new
    end

    def_delegators :document_factory, :action, :model, :csv, :json, :yaml

    # ----------------------------------------------------------------------
    # Utilities
    # ----------------------------------------------------------------------

    def clear_screen
      puts "\n" * 70
      $stdout.clear_screen
    end
  end
end

if ENV.fetch('KLUE_DEBUG', 'false').downcase == 'true'
  namespace = 'KManager::Version'
  file_path = $LOADED_FEATURES.find { |f| f.include?('k_manager/version') }
  version = KManager::VERSION.ljust(9)
  puts "#{namespace.ljust(35)} : #{version.ljust(9)} : #{file_path}"
end
