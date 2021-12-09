# frozen_string_literal: true

module KManager
  # TODO: Write Tests

  # A resource set holds a list of resources
  #
  # A resource could be a file, web-service, gist, ftp endpoint, memory object.
  #
  # ResourceSet is an internal component and is used by the ResourceManager
  #
  # The resource manager will create resources with the ResourceFactory and assign
  # those resources to the ResourceSet
  #
  # The only supported resource types so far are:
  #  - File
  #
  # Resources can be registered with the ResourceSet using register_* methods
  #
  # somepath
  # somepath/my_dsls
  # somepath/my_dsls/path1
  # somepath/my_dsls/path2
  # somepath/my_dsls/path2/child
  # somepath/my_dsls/path2/old        (skip this path)
  # somepath/my_data/
  # somepath/my_templates
  module Resources
    class ResourceSet
      include KLog::Logging

      attr_reader :area
      attr_reader :resources

      def initialize(area)
        @area = area
        @resources = []
      end

      def add(resource)
        return log.warn "Resource already added: #{resource.resource_path}" if find(resource)

        resource.area = area
        resources << resource
        resource
      end

      def add_resources(resource_list)
        resource_list.each do |resource|
          add(resource)
        end
      end

      def debug
        resources.each(&:debug)
      end

      private

      def find(resource)
        resources.find { |r| r.resource_path == resource.resource_path }
      end

      # def to_h
      #   resources.map(&:to_h)
      # end
    end
  end
end
