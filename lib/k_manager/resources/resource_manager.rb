# frozen_string_literal: true

module KManager
  # Container may replace project, at the moment it is in parallel
  # A container can be configured with watch paths, aka file resources that belong to the project
  #
  # somepath
  # somepath/my_dsls
  # somepath/my_dsls/path1
  # somepath/my_dsls/path2
  # somepath/my_dsls/path2/child
  # somepath/my_dsls/path2/old        (skip this path)
  # somepath/my_data/
  # somepath/my_templates
  #
  # Questions
  #   Is this really a ResourceContainer?
  #   What happens when resources are not based on files, where do that get stored, internally?
  #     - Do I have a UriSet (or)
  #     - Do I have siblings (FileResourceContainer, UriResourceContainer | RemoteResourceContainer)
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

  class ResourceManager
    attr_accessor :resources
    attr_accessor :fileset

    def initialize
      @factory = KManager::ResourceFactory.new
      @fileset = KFileset::FileSet.new
      @resources = []
    end

    def add_resource(resource_uri)
      resources << @factory.instance(resource_uri)
    end

    def add_resources
      add_web_resources
    end

    # def update_resource(path)
    #   uri = path_to_uri(path)
    #   reset_existing_resource(uri)
    #   add_resource(uri)
    #   load_resource_content
    # end

    def load_resource_content
      resources.each do |resource|
        resource.fire_action(:load_content)
      end
    end

    private

    def add_web_resources
      # TODO
    end

    def add_file_resources
      fileset.path_entries.each do |path_entry|
        add_resource(path_entry.uri)
      end
    end
  end
end
