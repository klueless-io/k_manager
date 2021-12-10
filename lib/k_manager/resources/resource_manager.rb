# frozen_string_literal: true

module KManager
  # TODO: Write tests

  # Usage1:
  #   manager = ResourceManager.new
  #   manager.add_resource('file:///david.csv')
  #   manager.add_resource('file:///david.txt', content_type: :json)
  #   manager.add_resource('https://gist.github.com/12345/david.csv', content_type: :csv)
  #   manager.load_resource_content
  #
  # Usage2:
  #   manager = ResourceManager.new
  #   manager.fileset.add('**/*.csv').add('**/*.json').add('lib/*.rb')
  #   manager.add_resources
  #   manager.load_resource_content
  #
  #
  # Usage KWatcher
  # WatchingDirctory('abc') do |path|
  #   manager.update_resource(path)
  # end

  # Example Director
  # KDoc.diagram(:k_resource) do

  #   component(:resource_manager) do
  #     attr_rw(:resources)
  #     attr_rw(:fileset)

  #     method(:add_resource, description: "I will add a resource to the manager") do
  #       param(:resource_uri, description: 'xxxx')
  #     end

  #     method(:add_resource, description: "I will add a collection of resources to the manager via fileset or webset")
  #     method(:load_resource_content)
  #   end

  #   def on_action
  #     build_drawio("#{self.name}_class"       , model: self.data, style: :class_diagram)
  #     build_drawio("#{self.name}_component"   , model: self.data, style: :component_diagram)
  #     build_drawio("#{self.name}_swim"        , model: self.data, style: :swimlane_diagram)
  #   end
  # end

  module Resources
    class ResourceManager
      attr_accessor :area

      attr_accessor :fileset
      attr_accessor :webset
      attr_accessor :memset

      # Resource set is built using file, web and memory resources
      attr_accessor :resource_set

      def initialize(area)
        @area             = area

        @fileset          = KFileset::FileSet.new
        @webset           = nil # TODO: when ready to implement URL based resources
        @memset           = nil # TODO: when ready to implement dynamic memory resources

        @resource_factory = KManager::Resources::ResourceFactory.new
        @resource_set     = KManager::Resources::ResourceSet.new(area)
      end

      def resources
        resource_set.resources
      end

      def resource_models
        resource_set.resources.map(&:as_model)
      end

      def add_resource_expand_path(file, **opts)
        add_resource(File.expand_path(file), **opts)
      end

      # Add a resource based on a resource_uri
      #
      # @param [URI|String] resource_uri Path to the resource, if the path uses file:/// then it will add a file resource, if the path http: or https: then a web resource will be added
      # TODO: Test File URI: relative_path
      # TODO: Test File URI: absolute_path
      # TODO: Test URI
      # TODO: Test URI (Web)
      # TODO: Test URI (File)
      def add_resource(resource_uri, **opts)
        resource_uri = parse_uri(resource_uri)
        resource_set.add(@resource_factory.instance(resource_uri, **opts))
      end

      def add_resources
        add_web_resources
        add_file_resources
      end

      # def update_resource(path)
      #   uri = path_to_uri(path)
      #   reset_existing_resource(uri)
      #   add_resource(uri)
      #   load_resource_content
      # end

      # Fire actions against all resources in this manager.
      #
      # @param [*Array<Symbol>] actions List of actions to run. [:load_content, :register_document, :load_document]
      def fire_actions(*actions)
        guard_action(actions)

        load_content        if actions.include?(:load_content)
        register_documents  if actions.include?(:register_document)
        load_documents      if actions.include?(:load_document)
      end

      def guard_action(actions)
        actions.each do |action|
          log.warn "ResourceManager.fire_actions - unknown action: #{action}" unless KManager::Resources::BaseResource.valid_action?(actions)
        end
      end

      def load_content
        resources.each do |resource|
          resource.fire_action(:load_content)
        end
      end

      def register_documents
        resources.each do |resource|
          resource.fire_action(:register_document)
        end
      end

      def load_documents
        resources.each do |resource|
          resource.fire_action(:load_document)
        end
      end

      def debug
        resources.each(&:debug)
      end

      private

      def parse_uri(uri)
        return uri if uri.is_a?(URI)
        return URI.parse(uri) if uri =~ URI::ABS_URI # https://stackoverflow.com/questions/1805761/how-to-check-if-a-url-is-valid

        URI.join('file:///', uri)
      end

      def add_web_resources
        # TODO
        # return if @webset.nil?
      end

      def add_file_resources
        fileset.path_entries.each do |path_entry|
          add_resource(path_entry.uri)
        end
      end
    end
  end
end
