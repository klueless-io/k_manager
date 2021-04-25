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
      include KLog::Logging

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

      attr_accessor :document

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
        @document = nil
        @documents = []
      end

      def attach_project(project)
        @project = project
        @project.add_resource(self)
        self
      end

      # Fire actions and keep track of status as they fire
      #
      # @param [Symbol] action what action is to be fired
      #  - :load_content for loading text content
      #  - :register_document for registering 1 or more documents (name and namespace) against the resource
      #  - :load_document for parsing the content into a document
      def fire_action(action)
        if action == :load_content && @status == :initialized
          load_content_action
        elsif action == :register_document && @status == :content_loaded
          register_document_action
        elsif action == :load_document && @status == :documents_registered
          load_document_action
        else
          puts 'unknown'
        end
      end

      def add_document(document)
        @documents << document
        document
      end

      # What identifying key does this resource have?
      #
      # Child resources will have different ways of working this out,
      # eg. File Resources will use the file name.
      def infer_key
        nil
      end

      def load_content
        log.warn 'you need to implement load_content'
      end

      def register_document
        log.warn 'you need to implement register_document'
      end

      def create_document
        KManager::Documents::BasicDocument.new(
          key: infer_key,
          type: type,
          namespace: '',
          project: project
        )
      end

      def attach_document(document, set_document: true, add_documents: true)
        # log.kv 'Key', infer_key
        # log.kv 'Type', @type
        # Need to support file namespaces, but to do that you need to have a root namespace defined that
        # would limit the size of the namespace and currently I need more information before that can happen
        # log.kv 'Namespace', ''
        # log.kv 'Project Key', project&.infer_key

        # log.kv 'Unique Key', document.unique_key

        @document = document     if set_document
        add_document(document)   if add_documents
      end

      def load_document
        log.warn 'you need to implement load_document'
      end

      private

      def load_content_action
        @status = :content_loading
        @content = nil
        load_content
        @status = :content_loaded
      end

      def register_document_action
        @status = :documents_registering
        register_document
        # document_factory.create_documents
        @status = :documents_registered
      end

      def load_document_action
        @status = :documents_loading
        load_document
        # document_factory.parse_content
        @status = :documents_loaded
      end
    end
  end
end
