# frozen_string_literal: true

module KManager
  module CreateDocument
    def model(key = nil, **opts)
      opts = { key: key }.merge(opts) unless key.nil?
      document = new_document(KManager::Documents::ModelDocument, **opts)

      attach_to_resource(document, change_resource_type: :dsl)
    end

    def attach_to_resource(document, change_resource_type: :dsl)
      KManager.target_resource&.attach_document(document, change_resource_type: :dsl)
      document
    end

    # Create an instance of a document
    #
    # @param [Class<DocumentTaggable>] klass type of document to create
    def new_document(klass, **opts)
      key = KManager.target_resource.documents.length.zero? ? KManager.target_resource.infer_key : nil

      opts = {
        resource: KManager.target_resource,
        key: key
      }.merge(opts)

      klass.new(**opts)
    end
  end
end
