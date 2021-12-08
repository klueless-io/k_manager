# frozen_string_literal: true

module KManager
  # KManager is designed to work with one or more areas of concern
  #
  # TODO: Write Tests
  module Manager
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

    # def dump
    #   JSON.pretty_generate(to_h)
    # end

    # def to_h
    #   {
    #     areas: areas.map(&:to_h)
    #   }
    # end

    # def dashboard_resources
    #   resources = areas.flat_map do |area|
    #     area.resource_manager.resource_set.resources.map do |resource|
    #       {
    #         area: area.name,
    #         area_namespace: area.namespace,
    #         **resource.attribute_values
    #       }
    #     end
    #   end
    #   {
    #     resources: resources
    #   }
    # end

    # def show_dashboard(opts, opts2) # (*sections)
    #   log.structure(dashboard_resources, opts)
    # end
  end
end
