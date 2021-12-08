# frozen_string_literal: true

module KManager
  # KManager is designed to work with one or more areas of concern
  #
  # TODO: Write Tests
  class Manager
    def areas
      @areas ||= []
    end

    def add_area(name, namespace: nil)
      area = find_area(name)

      return area if area

      area = KManager::Area.new(name: name, namespace: namespace)
      areas << area
      area
    end

    def fire_actions(*actions)
      areas.each do |area|
        area.resource_manager.fire_actions(*actions)
      end
    end

    def find_area(name)
      areas.find { |a| a.name == name }
    end

    def find_area(name)
      areas.find { |a| a.name == name }
    end

    def debug(*sections)
      areas.each do |area|
        area.debug(*sections)
      end
    end


    # # May replace config with default channel name
    # # Channels represent configurations that are independent of project or builder,
    # # but a project may want to have a default channel that it supplies
    # def initialize(name, config = nil, **opts)
    #   raise KType::Error, 'Provide a project name' unless name.is_a?(String) || name.is_a?(Symbol)

    #   @name = name
    #   @config = config || KManager::Configuration::ProjectConfig.new
    #   @resources = []

    #   initialize_opts(opts)
    # end
  end
end
