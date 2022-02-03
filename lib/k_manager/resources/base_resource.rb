# frozen_string_literal: true

module KManager
  module Resources
    # A resource represents text based content in the project. The content
    # maybe data, interpreted ruby code or a combination of the two.
    #
    # Any non-binary file that is useful for processing.
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
      include KDoc::Guarded

      ACTIONS = %i[load_content register_document load_document].freeze

      class << self
        def valid_action?(action)
          ACTIONS.include?(action)
        end
      end

      attr_reader :uri # https://ruby-doc.org/stdlib-2.6.1/libdoc/uri/rdoc/URI/Generic.html

      # TODO: Refactor from status to state and extract to a State class
      # Status of the resource
      # - :alive (i am alive, or instantiated)
      # - :content_loading
      # - :content_loaded
      # - :documents_registering
      # - :documents_registered
      # - :documents_loading
      # - :documents_loaded
      attr_reader :status

      # What content type does the underlying resource type generally contain
      #
      # Examples:
      #
      # :csv        - CSV text content
      # :json       - JSON text content
      # :yaml       - YAML text content
      # :xml        - XML text content
      # :ruby       - Ruby code file of unknown capability
      # :ruby_dsl   - Ruby code holding some type of known DSL such as a KDoc
      #               DISCUSS: should this subtype be delegated to an attribute on a responsible class
      attr_reader :content_type

      # TODO: Write Test
      # Area is an option property what will only be set when working with Area
      attr_accessor :area

      # Optional namespace that the resource belongs to.
      attr_reader :namespace

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
      # NAMESPACE can probably be taken from file set relative path
      def initialize(uri, **opts)
        self.uri      = uri

        @status       = :alive
        @area         = value_remove(opts, :area)
        @namespace    = value_remove(opts, :namespace)
        @content_type = @content_type || value_remove(opts, :content_type) || infer_content_type || default_content_type
        @content      = value_remove(opts, :content)

        # attach_project(opts[:project]) if opts[:project]
        @documents = []
      end

      def source_path
        # Expectation that uri is of type URI::HTTP or URI::HTTPS
        uri.to_s
      end

      # TODO: Is this really needed?
      def document
        @document ||= documents&.first
      end

      def activated?
        # log.section_heading("Am I activated?")
        # log.kv 'URI', uri
        # log.kv 'ACTIVE URI', self.area.manager.active_uri
        return false if area.nil?

        uri.to_s == area.manager.active_uri.to_s
      end

      # Fire actions and keep track of status as they fire
      #
      # @param [Symbol] action what action is to be fired
      #  - :load_content for loading text content
      #  - :register_document for registering 1 or more documents (name and namespace) against the resource
      #  - :load_document for parsing the content into a document
      # rubocop:disable Metrics/CyclomaticComplexity
      def fire_action(action)
        # TODO: Write test for valid
        return unless valid?

        case action
        when :load_content
          load_content_action if alive?
        when :register_document
          register_document_action if content_loaded?
        when :load_document
          load_document_action if documents_registered?
        else
          log.warn "Action: '#{action}' is invalid for status: '#{status}'"
        end
      end
      # rubocop:enable Metrics/CyclomaticComplexity

      def fire_next_action
        if alive?
          fire_action(:load_content)
        elsif content_loaded?
          fire_action(:register_document)
        elsif documents_registered?
          fire_action(:load_document)
        end
      end

      # What identifying key does this resource have?
      #
      # Child resources will have different ways of working this out,
      # eg. File Resources will use the file name.
      def infer_key
        nil
      end

      def load_content
        # log.warn 'you need to implement load_content'
      end

      def register_document
        # log.warn 'you need to implement register_document'
        KManager::Resources::ResourceDocumentFactory.create_documents(self)
      end

      # rubocop:disable Lint/RescueException
      def load_document
        # log.warn 'you need to implement register_document'
        documents.each do |document|
          document.execute_block(run_actions: activated?)
        end
      rescue Exception => e
        guard(e.message)
        debug
        log.exception(e, style: KManager.opts.exception_style)
        # log.exception(e, style: :short)
      end
      # rubocop:enable Lint/RescueException

      # This is when you need a simple container
      def new_document(data)
        document = KDoc::Container.new(
          key: infer_key,
          type: content_type,
          namespace: namespace,
          default_data_type: data.class,
          data: data
        )
        attach_document(document)
      end

      def attach_document(document, change_content_type: nil)
        @content_type = change_content_type if change_content_type

        document.owner = self
        @documents << document
        document
      end

      def scheme
        uri&.scheme&.to_sym || default_scheme
      end

      def host
        uri&.host
      end

      # What schema does the underlying resource connect with by default
      #
      # Examples:
      #
      # :file
      # :web (http: https: fpt:)
      # :mem - some type of memory structure
      def default_scheme
        :unknown
      end

      # Optionally overridden, this is the case with FileResource
      def infer_content_type
        nil
      end

      def default_content_type
        :unknown
      end

      def alive?
        @status == :alive
      end

      def content_loaded?
        @status == :content_loaded
      end

      def documents_registered?
        @status == :documents_registered
      end

      def documents_loaded?
        @status == :documents_loaded
      end

      # Setting the URI can be overridden by WebResource and FileResource
      def uri=(uri)
        return if uri.nil?

        @uri = URI(uri) if uri.is_a?(String)
        @uri = uri      if uri.is_a?(URI)

        # log.kv 'uri type', uri.class
        # It might be useful to have a Resource Specific Guard being called to warn if the wrong URI type is inferred from here
        # supported URI::Class (Generic, File, HTTP, HTTPS)
      end

      # rubocop:disable Metrics/AbcSize
      def attribute_values(prefix = nil)
        result = {}
        result["#{prefix}id".to_sym]              = object_id
        result["#{prefix}key".to_sym]             = infer_key
        result["#{prefix}namespace".to_sym]       = namespace
        result["#{prefix}status".to_sym]          = status
        result["#{prefix}source".to_sym]          = source_path
        result["#{prefix}content_type".to_sym]    = content_type
        result["#{prefix}content".to_sym]         = content
        result["#{prefix}document_count".to_sym]  = documents.length
        result["#{prefix}errors".to_sym]          = error_hash
        result["#{prefix}valid".to_sym]           = valid?
        result["#{prefix}scheme".to_sym]          = scheme
        result["#{prefix}host".to_sym]            = host
        result
      end
      # rubocop:enable Metrics/AbcSize

      # rubocop:disable Metrics/AbcSize
      def debug(heading = 'resource')
        width = 20
        log.section_heading(heading)
        log.kv 'area'             , area.name                                             , width if area
        log.kv 'area namespace'   , area.namespace                                        , width if area
        log.kv 'scheme'           , scheme                                                , width
        log.kv 'host'             , host , width
        log.kv 'source_path'      , source_path                                           , width
        log.kv 'content_type'     , content_type                                          , width
        log.kv 'status'           , status                                                , width
        log.kv 'content'          , content.nil? ? '' : content[0..100].gsub("\n", '\n')  , width
        log.kv 'documents'        , documents.length                                      , width

        yield if block_given?

        log_any_messages

        # log.kv 'infer_key', infer_key                                             , width
        # log.kv 'project'  , project

        documents.each(&:debug)
        nil
      end
      # rubocop:enable Metrics/AbcSize

      private

      def value_remove(opts, key)
        return opts.delete(key) if opts.key?(key)

        nil
      end

      def load_content_action
        @status = :content_loading
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
