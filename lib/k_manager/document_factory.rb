# frozen_string_literal: true

module KManager
  # Help factories for creating documents quickly
  #
  # Example:
  #
  #   KManager.csv(file: 'somepath/somefile.csv') do
  #     load
  #   end
  module DocumentFactory
    include KLog::Logging

    # Instance of the currently focused resource
    attr_reader :current_resource

    def resource_mutex
      @resource_mutex ||= Mutex.new
    end

    def for_resource(resource = nil)
      resource_mutex.synchronize do
        @current_resource = resource
        yield(current_resource)

        # Make sure the current resource is released with the lock
        @current_resource = nil
      end
    end

    def for_current_resource
      raise KManager::Error, 'Attempting to yield current_resource, when a different thread has the lock?' unless resource_mutex.owned?

      yield(@current_resource)
    end

    # If document gets created dynamically due to class_eval then they
    # can attach themselves to the currently focussed resource.
    #
    # It will throw an error if for_resource has not been called earlier
    # in the thread lifecycle.
    def attach_to_current_resource(document, change_content_type: nil)
      return document unless current_resource

      for_current_resource do |resource|
        resource.attach_document(document, change_content_type: change_content_type)
      end
    end

    # Create a KDoc::Model instance
    def model(key = nil, **opts, &block)
      document = new_document(KDoc::Model, key, **opts, &block)

      attach_to_current_resource(document, change_content_type: :dsl)
    end

    # Create a KDoc::CsvDoc instance
    def csv(key = nil, **opts, &block)
      document = new_document(KDoc::CsvDoc, key, **opts, &block)

      attach_to_current_resource(document, change_content_type: :dsl)
    rescue StandardError => e
      log.error(e)
    end

    # Create a KDoc::JsonDoc instance
    def json(key = nil, **opts, &block)
      document = new_document(KDoc::JsonDoc, key, **opts, &block)

      attach_to_current_resource(document, change_content_type: :dsl)
    rescue StandardError => e
      log.error(e)
    end

    # Create a KDoc::YamlDoc instance
    def yaml(key = nil, **opts, &block)
      document = new_document(KDoc::YamlDoc, key, **opts, &block)

      attach_to_current_resource(document, change_content_type: :dsl)
    rescue StandardError => e
      log.error(e)
    end

    # Create an instance of a document
    #
    # @param [Class<DocumentTaggable>] klass type of document to create
    def new_document(klass, key = nil, **opts, &block)
      # Should be able to infer
      # key = KManager.current_resource.documents.length.zero? ? KManager.current_resource.infer_key : nil

      # klass.new(key, **{ owner: KManager.current_resource }.merge(opts), &block)
      klass.new(key, **opts, &block)
    end
  end
end
