# frozen_string_literal: true

module KManager
  class Manager
    attr_reader :name
    attr_reader :root_namespace
    attr_reader :config

    def initialize(**opts)
      @name = opts[:name]
      @root_namespace = opts[:root_namespace]
      @config = KBuilder.configure(@name)
    end

    def resource_manager
      @resource_manager ||= ResourceManager.new
    end
  end
end
