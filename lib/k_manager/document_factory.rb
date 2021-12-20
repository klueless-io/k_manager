# frozen_string_literal: true

module KManager
  # Factories for creating common DSL documents quickly
  #
  # Example:
  #
  #   KManager.csv(file: 'somepath/somefile.csv') do
  #     load
  #   end
  class DocumentFactory
    include KLog::Logging

    # Create a KDoc::Model instance
    def action(key = nil, **opts, &block)
      document = new_document(KDoc::Action, key, **opts, &block)

      attach_to_current_resource(document, change_content_type: :ruby)
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

    private

    # If document gets created dynamically due to class_eval then they
    # can attach themselves to the currently focussed resource.
    #
    # It will throw an error if for_resource has not been called earlier
    # in the thread lifecycle.
    def attach_to_current_resource(document, change_content_type: nil)
      return document unless KManager.current_resource

      KManager.for_current_resource do |resource|
        resource.attach_document(document, change_content_type: change_content_type)
      end
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
