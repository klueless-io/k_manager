# frozen_string_literal: true

module KManager
  class Area
    include KLog::Logging
    extend Forwardable

    attr_reader :manager
    # TODO: I have not got a use for area name yet, it may be able to drive default config, but not sure.
    attr_reader :name
    attr_reader :namespace
    attr_reader :config

    def initialize(**opts)
      @manager    = opts[:manager]
      @name       = opts[:name]

      raise 'Area name is required' unless @name

      @namespace  = opts[:namespace] || @name
      @config     = KConfig.configuration(@name)
    end

    def resource_manager
      @resource_manager ||= KManager::Resources::ResourceManager.new(self)
    end

    def_delegators :resource_manager, :resource_changed, :resources, :find_by_uri

    def debug(*sections)
      log.kv 'Area'           , name
      log.kv 'Namespace'      , namespace

      resource_manager.debug if sections.include?(:resource) || sections.include?(:resources)
      config.debug if sections.include?(:config)
    end

    # rubocop:disable Metrics/AbcSize
    def attribute_values(prefix = nil)
      result = {}
      result["#{prefix}name".to_sym]                  = name
      result["#{prefix}namespace".to_sym]             = namespace
      result["#{prefix}resource_count".to_sym]        = resource_manager.resources.length
      result["#{prefix}document_count".to_sym]        = resource_manager.resources.sum { |resource| resource.documents.length }
      result
    end
    # rubocop:enable Metrics/AbcSize
  end
end
