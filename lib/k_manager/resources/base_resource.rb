# frozen_string_literal: true

module KManager
  module Resources
    # A resource represents text based content in the project. The content
    # maybe data, interpreted ruby code or a combination of the two.
    #
    # Currently resources refer to file based content, but it is envisaged
    # that resources could come from a distributed source such as Gist,
    # WebService, or even FTP.
    #
    # Resources can hold different types of static and smart content.
    # Examples of static content include JSON, YAML and CSV
    # Example of smart content include Ruby classes, PORO's and DSL's.
    #
    # NOTE: The resource represents the text content, but not the actual data or
    # code that resides there. Instead a document is created to store the data or
    # code. The reason for this is that some content files, especially DSL's may
    # have more then one interpreted ruby structure included in the content and so
    # a document gets created for each DSL, but for all other files, there is
    # generally only one document.
    class BaseResource
      # Status of the resource
      # - :initialized
      # - :content_loading
      # - :content_loaded
      # - :documents_registering
      # - :documents_registered
      # - :documents_loading
      # - :documents_loaded
      attr_reader :status

      # Where is the source of content
      #
      # Implement in child classes, examples: :file, :uri, :dynamic
      attr_reader :source

      # Where is the type of the
      #
      # Implement in child classes, examples: :csv, :json, :ruby, :dsl, :yaml
      attr_reader :type

      attr_reader :project

      # Content of resource, use read content to load this property
      attr_reader :content

      # List of documents derived from this resource
      #
      # Most resources will create one document, but a DSL can generate
      # multiple documents and some future resources may do as well
      #
      # Currently there will always be a minimum of 1 document even if the resource
      # is not a data resource, e.g. Ruby class
      attr_accessor :documents

      # Initialize base for resources
      #
      # @param [Hash] **opts Options for initializing the resource
      # @option opts [Project] :project attach the resource to a project
      def initialize(**opts)
        @status = :initialized
        @source = :unknown
        @type = :unknown

        attach_project(opts[:project]) if opts[:project]
        @documents = []
      end

      def attach_project(project)
        @project = project
        @project.add_resource(self)
        self
      end
    end
  end
end
