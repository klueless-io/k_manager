# frozen_string_literal: true

module KManager
  module Overview
    class Queries
      attr_reader :manager

      def initialize(manager)
        @manager = manager
      end

      def areas
        manager.areas.map(&:attribute_values)
      end

      def resources
        manager.areas.flat_map do |area|
          # TODO: Some of these properties are only available on FileResource
          #       This will need to be refactored when implementing Mem and Web Resource
          area.resource_manager.resource_set.resources.map do |resource|
            {
              **area.attribute_values('area_'),
              **resource.attribute_values('')
            }
          end
        end
      end

      # rubocop:disable Metrics/AbcSize
      def documents
        manager.areas.flat_map do |area|
          area.resource_manager.resource_set.resources.flat_map do |resource|
            resource.documents.map do |document|
              {
                **area.attribute_values('area_'),
                **resource.attribute_values('resource_'),
                document_id: document.object_id,
                document_data: document.data,
                document_key: document.key,
                document_namespace: document.namespace,
                document_tag: document.tag,
                document_type: document.type,
                document_errors: document.error_hash,
                document_valid: document.valid?
              }
            end
          end
        end
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
