# frozen_string_literal: true

module KManager
  module Documents
    # Tag a document with attributes that can be used to uniquely identify
    # a document within a project or namespace
    #
    # Examples:
    #   User DSL could be tagged user_entity
    #   Blue print DSL for building a data layer User could be tagged user_blueprint
    #   Users.csv file could be tagged data_files_users_csv
    #   Account DSL in the CRM project could be tagged crm_account_entity
    #   AccountController DSL in the CRM project could be tagged crm_controllers_account_controller
    module DocumentTaggable
      # Name of the document (required)
      #
      # Examples: user, account, country
      attr_reader :key

      # Type of document (optional, but will set to :default_document_type if not provided)
      #
      # Examples by data type
      #   :csv, :yaml, :json, :xml
      #
      # Examples by shape of the data in a DSL
      #   :entity, :microapp, blueprint
      attr_reader :type

      # Namespace of the document (optional, '' if not set)
      #
      # When using a data file, this should be based on the relative file path
      # When using a DSL data file, this will be manually configured
      attr_reader :namespace

      # Project that this document belongs to (optional)
      attr_reader :project

      # Project key is inferred from the attached project ('' if project not set)
      attr_reader :project_key

      # Errors in documents can be stored against the document
      #
      # This helps debugging invalid DSL's and data documents
      attr_reader :error

      def initialize_document_tags(**opts)
        @key = opts[:key] || SecureRandom.alphanumeric(4)
        @type = opts[:type] || default_document_type # KDoc.opinion.default_model_type
        @namespace = opts[:namespace] || ''
        @project = opts[:project]
        @project_key = project&.infer_key
      end

      # This method should be implemented on the document class
      # generally it will return a :symbol
      # def default_document_type; end;

      # The unique key on resources provides a way to prevent conflicts
      # between resource names, resource types, local namespaces and projects.
      def unique_key
        return @unique_key if defined? @unique_key

        @unique_key = begin
          raise KDoc::Error, 'key is required when generating unique key' if key.nil? || key.empty?

          [project_key, namespace, key, type]
            .reject { |k| k.nil? || k == '' }
            .map { |k| k.to_s.gsub('_', '-') }
            .join('-')
        end
      end
    end
  end
end
