# frozen_string_literal: true

module KManager
  module Resources
    # Create documents based on the target resource
    class BuildDocuments
      include KLog::Logging

      # TODO: The original system always created 1 document, so need to consider if 0-more should become 1-more

      # Build 0-more documents and attach them to the resource.
      #
      # The resource is stored in the KManager.current_resource context
      # and wrapped by a Mutex so that any self registering documents can
      # figure out which resource to register themselves against
      def build(target_resource)
        KManager.for_resource(target_resource) do |resource|
          process_resource(resource)
        end
      end

      private

      # Create 0-Many documents and attach to the resource
      #
      # @param [BaseResource] resource The resource that created and is thus owns the document
      # @param [Symbol] content_type Type of content, %i[csv json yaml ruby unknown]
      # @param [String] key is the unique resource key
      # @param [String] content Resource content as a raw string, examples could be CSV, JSON, YAML, RUBY or some other text content
      def process_resource(resource)
        case resource.content_type
        when :csv
          attach_container_document(resource, process_csv(resource.content))
        when :json
          attach_container_document(resource, process_json(resource.content))
        when :yaml
          attach_container_document(resource, process_yaml(resource.content))
        when :ruby
          process_ruby(resource)
          :ruby
        else
          :unknown
        end
      end

      # TODO: attach_container_document probably should use CreateDocument.attach_to_resource
      def attach_container_document(resource, data)
        # default_data = data.is_a?(Array) ? [] : {}
        document = KDoc::Container.new(
          key: resource.infer_key,
          type: resource.content_type,
          namespace: resource.namespace,
          data: data
        )
        resource.attach_document(document)
      end

      def process_csv(content)
        rows = []

        CSV.parse(content, headers: true, header_converters: :symbol) do |row|
          rows << row.to_h
        end
        rows
      rescue StandardError => e
        log.exception(e, style: :message)
        []
      end

      def process_json(content)
        JSON.parse(content)
      rescue StandardError => e
        log.exception(e, style: :message)
        {}
      end

      def process_yaml(content)
        YAML.safe_load(content)
      rescue StandardError => e
        log.exception(e, style: :message)
        {}
      end

      def process_ruby(resource)
        # puts content
        # KManager::Manager.current_resource
        # KDsl.target_resource = self

        Object.class_eval resource.content

        # # Only DSL's will add new resource_documents
        # if documents.length > 0
        #   resource.resource_type = KDsl::Resources::Resource::TYPE_RUBY_DSL
        # end
      rescue StandardError => e
        # Report the error but still add the document so that you can see
        # it in the ResourceDocument list, it will be marked as Error
        # resource.error = ex
        resource.guard(e.message)
        log.exception(e, style: :short)

        # L.exception resource.error

        # KDsl.target_resource = nil

        # # A regular ruby file would not add resource_documents
        # # so create one manually
        # add_document(new_document) if documents.length === 0
      end

      # # TEST REQUIRED
      # def add_document(document)
      #   # project.register_dsl(document)
      #   project.add_resource_document(self, document)
      #   document.resource = self
      #   documents << document
      #   document
      # end
    end
  end
end
