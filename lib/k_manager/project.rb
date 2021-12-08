# frozen_string_literal: true

module KManager
  require 'handlebars/helpers/string_formatting/dasherize'

  # A project represents all the DSL and Data resources that are available, it keeps a track of
  # the in memory state of the resources, are they loaded into memory or not.
  class Project
    # Project name
    attr_reader :name

    # Project namespace, aka namespace root
    attr_reader :namespace

    # Configuration for this project
    attr_reader :config

    # List of resources attached to this project (This can be come a fileset)
    attr_reader :resources

    # May replace config with default channel name
    # Channels represent configurations that are independent of project or builder,
    # but a project may want to have a default channel that it supplies
    def initialize(name, config = nil, **opts)
      raise KType::Error, 'Provide a project name' unless name.is_a?(String) || name.is_a?(Symbol)

      @name = name
      @config = config || KManager::Configuration::ProjectConfig.new
      @resources = []

      initialize_opts(opts)
    end

    def add_resource(resource)
      # Need to check if this and resource.attach_project need to delegate to each other
      # Need to check that resources can't be added twice
      # Tests are required
      @resources << resource
    end

    # Infer key is the project name stored in dash-case
    def infer_key
      Handlebars::Helpers::StringFormatting::Snake.new.parse(name) # .to_s.gsub('_', '-'))
    end

    private

    def initialize_opts(opts)
      # How am I really using project name spacing?
      # project name is often a good default for the namespace
      @namespace = opts[:namespace] || name
    end
  end
end
