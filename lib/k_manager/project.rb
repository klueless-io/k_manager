# frozen_string_literal: true

module KManager
  # A project represents all the DSL and Data resources that are available, it keeps a track on the
  # in memory state of the resources, are they loaded into memory or not.
  class Project
    # Project name
    attr_reader :name

    # Root namespace
    attr_reader :root_namespace

    # Configuration for this project
    attr_reader :config

    def initialize(name, config = nil, **opts)
      raise KType::Error, 'Provide a project name' unless name.is_a?(String) || name.is_a?(Symbol)

      @name = name
      @config = config || KManager::Configuration::ProjectConfig.new

      initialize_opts(opts)
    end

    private

    def initialize_opts(opts)
      # project name is often a good default for the root_namespace
      @root_namespace = opts[:root_namespace] || name
    end
  end
end
