# frozen_string_literal: true

module KManager
  # KManager is designed to work with one or more areas of concern
  #
  # TODO: Write Tests
  class Manager
    attr_accessor :active_uri

    # NOTE: rename current_resource to active_resource, focused_resource?
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

    # Usage
    #
    # KManager.opts.sleep                       = 10
    # KManager.opts.reboot_on_kill              = 0
    # KManager.opts.exception_style             = :short
    # KManager.opts.show.time_taken             = true
    # KManager.opts.show.finished               = true
    # KManager.opts.show.finished_message       = 'FINISHED :)'
    
    Options = Struct.new(
      :app_name,
      :exception_style,
      :reboot_on_kill,
      :reboot_sleep,
      :sleep,
      :show
    )

    Show = Struct.new(
      :time_taken,
      :finished,
      :finished_message
    )

    # @param [Integer] sleep Seconds to sleep after running, 0 = no sleep
    # @param [Symbol] exception_style Format for exception messages caught by watcher.
    #   :message - message only
    #   :short - message and short backtrace
    #   :long - message and long backtrace
    def opts
      @opts ||= Options.new('', :message, false, 1, 0, Show.new(true, true, 'FINISHED :)'))
    end

    def areas
      @areas ||= []
    end

    def add_area(name, namespace: nil)
      area = find_area(name)

      return area if area

      area = KManager::Area.new(manager: self, name: name, namespace: namespace)
      areas << area
      area
    end

    def find_document(tag, area: nil)
      area = resolve_area(area)

      log.error 'Could not resolve area' if area.nil?

      log.line
      log.error(tag)
      log.line

      documents = area.resources.flat_map(&:documents)
      documents.find { |d| d.tag == tag }
    end

    def fire_actions(*actions)
      areas.each do |area|
        # delegate
        area.resource_manager.fire_actions(*actions)
      end
    end

    def find_area(name)
      areas.find { |a| a.name == name }
    end

    def resolve_area(area)
      if area.nil?
        return KManager.current_resource.area if KManager.current_resource

        return KManager.areas.first
      end

      return area if area.is_a?(Area)

      find_area(name)
    end

    # Return a list of resources for a URI.
    #
    # Generally only one resource is returned, unless the URI exists in more than one area
    def resources_by_uri(uri)
      areas.map { |area| area.resources_by_uri(uri) }.compact
    end

    def resource_changed(uri, state)
      @active_uri = uri
      areas.each do |area|
        area.resource_changed(uri, state)
      end
      @active_uri = nil
    end

    def reboot
      puts 'Fire reboot'
      KManager.opts.reboot_on_kill = 1
      raise SystemExit
    end

    def debug(*sections)
      log.structure(KUtil.data.to_hash(opts))

      areas.each do |area|
        area.debug(*sections)
      end
    end

    # def cons

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
