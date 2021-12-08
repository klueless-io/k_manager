# frozen_string_literal: true

module KManager
  class Area
    include KLog::Logging

    # TODO: I have not got a use for area name yet, it may be able to drive default config, but not sure.
    attr_reader :name
    attr_reader :namespace
    attr_reader :config

    def initialize(**opts)
      @name = opts[:name]
      @namespace = opts[:namespace]
      @config = KBuilder.configuration(@name)
    end

    def resource_manager
      @resource_manager ||= KManager::Resources::ResourceManager.new(self)
    end

    # TODO: Refactor debug & dashboard
    # Need to come up with a technique for debug and dashboard so that the code is dry
    # Either use a presenter concept, or use a mix-in concept

    def debug(*sections)
      log.kv 'Area'           , name
      log.kv 'Namespace'      , namespace

      resource_manager.debug if sections.include?(:resource) || sections.include?(:resources)
      config.debug if sections.include?(:config)
    end

    def attribute_values(prefix = nil)
      result = {}
      result["#{prefix}name".to_sym]                  = name
      result["#{prefix}namespace".to_sym]             = namespace
      result["#{prefix}resource_count".to_sym]        = resource_manager.resources.length
      result["#{prefix}document_count".to_sym]        = resource_manager.resources.sum { |resource| resource.documents.length }
      result
    end

    def to_h
      {
        area: name,
        namespace: namespace,
        resources: resource_manager.resource_set.to_h
      }
    end

    def as_model(shape:)
      return KManager::Models::Area.new(name: name, namespace: namespace, resources: resource_manager.resource_models) if shape == :area
      return KManager::Models::AreaItem.new(name: name, namespace: namespace) if shape == :area_item

      raise "Invalid shape: #{shape}"
    end

    # def dashboard(*sections)
    #   log.structure(dump)
    #   # log.kv 'Area'           , name
    #   # log.kv 'Namespace'      , namespace
    #   # resource_manager.debug if sections.include?(:resource) || sections.include?(:resources)
    #   # config.debug if sections.include?(:config)
    # end
  end
end
