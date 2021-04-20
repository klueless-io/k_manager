# frozen_string_literal: true

module KManager
  # A project represents all the DSL and Data resources that are available, it keeps a track of
  # the in memory state of the resources, are they loaded into memory or not.
  class Project
    # Project name
    attr_reader :name

    # Project namespace, aka namespace root
    attr_reader :namespace

    # Configuration for this project
    attr_reader :config

    # List of resources attached to this project
    attr_reader :resources

    def initialize(name, config = nil, **opts)
      raise KType::Error, 'Provide a project name' unless name.is_a?(String) || name.is_a?(Symbol)

      @name = name
      @config = config || KManager::Configuration::ProjectConfig.new
      @resources = []

      initialize_opts(opts)
    end

    def add_resource(resource)
      @resources << resource
    end

    private

    def initialize_opts(opts)
      # project name is often a good default for the namespace
      @namespace = opts[:namespace] || name
    end
  end
end
