# frozen_string_literal: true

module KManager
  module Overview
    # Generate dashboard information on the console
    #
    # TODO: ConsoleDashboard and HtmlConsole
    class Dashboard
      include KLog::Logging

      attr_reader :queries

      def initialize(manager)
        @queries = KManager::Overview::Queries.new(manager)
      end

      def areas
        data = queries.areas.map { |hash| KManager::Overview::Area.new(hash) }
        graph = {
          areas: {
            columns: [
              :name,
              :namespace,
              { resource_count: { display_method: ->(row) { blank_zero(row.resource_count) } } },
              { document_count: { display_method: ->(row) { blank_zero(row.document_count) } } }

            ]
          }
        }
        display(:areas, 'Areas', graph, data)
      end

      # rubocop:disable Metrics/AbcSize
      def resources
        # sort and remove repeating area
        data = grouped_resources(queries.resources).map { |hash| KManager::Overview::Resource.new(hash) }
        graph = {
          resources: {
            columns: [
              { area:           { display_method: ->(row) { row.area_name } } },
              { area_ns:        { display_method: ->(row) { row.area_namespace } } },
              { resource_docs:  { display_method: ->(row) { resource_document_count(row) } } },
              { resource_id:    { display_method: ->(row) { blank_zero(row.id) } } },
              { key:            { display_method: ->(row) { row.key } } },
              { namespace:      { display_method: ->(row) { row.namespace } } },
              { status:         { display_method: ->(row) { row.status } } },
              { content_type:   { display_method: ->(row) { row.content_type } } },
              { content:        { display_method: ->(row) { row.content } } },
              { document_count: { display_method: ->(row) { blank_zero(row.document_count) } } },
              { valid:          { display_method: ->(row) { row.valid } } },
              { error_count:    { display_method: ->(row) { blank_zero(row.errors.length) } } },
              { scheme:         { display_method: ->(row) { row.scheme } } },
              { root:           { display_method: ->(row) { row.scheme == :file ? '' : row.host } } },
              { relative_path:  { display_method: ->(row) { right(50, row.relative_path) }, width: 50 } },
              { exist:          { display_method: ->(row) { row.exist } } } # ,
              # { resource_path:  { display_method: ->(row) { row.path }, width: 100 } }
            ]
          }
        }

        display(:resources, 'Resource List', graph, data)
      end

      def documents
        data = grouped_documents(queries.documents).map { |hash| KManager::Overview::Document.new(hash) }

        graph = {
          resources: {
            columns: [
              { area:               { display_method: ->(row) { row.area_name } } },
              { area_ns:            { display_method: ->(row) { row.area_namespace } } },
              { resource_docs:      { display_method: ->(row) { resource_document_count(row) } } },
              { resource_id:        { display_method: ->(row) { blank_zero(row.resource_id) } } },
              # { key:                { display_method: -> (row) { row.resource_key } } },
              # { namespace:          { display_method: -> (row) { row.resource_namespace } } },
              # { status:             { display_method: -> (row) { row.resource_status } } },
              # { content_type:       { display_method: -> (row) { row.resource_content_type } } },
              # { content:            { display_method: -> (row) { row.resource_content } } },
              # { document_count:     { display_method: -> (row) { blank_zero(row.resource_document_count) } } },
              # { valid:              { display_method: -> (row) { row.resource_valid } } },
              # { error_count:        { display_method: -> (row) { blank_zero(row.resource_errors.length) } } },
              # { scheme:             { display_method: -> (row) { row.resource_scheme } } },
              # # { path:               { display_method: -> (row) { row.resource_path } } },
              # { exist:              { display_method: -> (row) { row.resource_exist } } },
              { document_id:        { display_method: ->(row) { blank_zero(row.document_id) } } },
              { data:               { display_method: ->(row) { row.document_data } } },
              { error_count:        { display_method: ->(row) { blank_zero(row.document_errors.length) } } },
              { key:                { display_method: ->(row) { row.document_key } } },
              { namespace:          { display_method: ->(row) { row.document_namespace } } },
              { tag:                { display_method: ->(row) { row.document_tag } } },
              { type:               { display_method: ->(row) { row.document_type } } },
              { relative_path:      { display_method: ->(row) { right(50, resource_path_location(row.resource_relative_path, row.document_location)) }, width: 50 } }
            ]
          }
        }

        display(:resources, 'Document List', graph, data)
      end
      # rubocop:enable Metrics/AbcSize

      private

      def resource_path_location(path, location)
        return path unless location

        "#{path}:#{location}"
      end

      def display(section, title, graph, data)
        data = {
          section => data
        }
        opts = {
          title: title,
          title_type: :heading,
          show_array_count: false,
          graph: graph
        }
        log.structure(data, **opts)
      end

      def blank_zero(value)
        return nil if value.nil? || (value.is_a?(Integer) && value.zero?)

        value
      end

      def lpad(size, value)
        value.to_s.rjust(size)
      end

      def right(size, value)
        value.chars.last(size).join
      end

      def resource_document_count(row)
        return nil if row.area_resource_count.nil? && row.area_document_count.nil?

        resource = lpad(2, blank_zero(row.area_resource_count))
        document = lpad(2, blank_zero(row.area_document_count))
        [resource, document].join(' / ')
      end

      # rubocop:disable Metrics/AbcSize
      def grouped_resources(resources)
        return resources if resources.length < 2

        grouped = resources.group_by { |resource| resource[:area_name] }
        grouped.flat_map do |group|
          group[1].map.with_index do |resource, index|
            new_resource = resource.clone
            if index.positive?
              new_resource[:area_name]            = nil
              new_resource[:area_namespace]       = nil
              new_resource[:area_resource_count]  = nil
              new_resource[:area_document_count]  = nil
            end
            new_resource
          end
        end
      end

      def grouped_documents(documents)
        return documents if documents.length < 2

        grouped = documents.group_by { |document| document[:area_name] }
        grouped.flat_map do |group|
          last_resource_id = 0
          group[1].map.with_index do |document, index|
            new_document = document.clone
            if index.positive?
              new_document[:area_name]            = nil
              new_document[:area_namespace]       = nil
              new_document[:area_resource_count]  = nil
              new_document[:area_document_count]  = nil

              new_document[:resource_id] = nil if last_resource_id == group[1][index][:resource_id]

            end
            last_resource_id = document[:resource_id]
            new_document
          end
        end
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
