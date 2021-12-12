# frozen_string_literal: true

# KDomain::Schemas::Domain::Column
# KDomain::Schemas::Domain::Model

module KManager
  module Overview
    module Types
      include Dry.Types()
    end

    class Error < Dry::Struct
    end

    class Area < Dry::Struct
      attribute :name                     , Types::Strict::String | Types::Strict::Symbol
      attribute :namespace                , Types::Strict::String.optional.default(nil) | Types::Strict::Symbol.optional.default(nil)
      attribute :resource_count           , Types::Strict::Integer
      attribute :document_count           , Types::Strict::Integer
    end

    class Resource < Dry::Struct
      attribute :area_name                , Types::Strict::String.optional.default(nil) | Types::Strict::Symbol.optional.default(nil)
      attribute :area_namespace           , Types::Strict::String.optional.default(nil) | Types::Strict::Symbol.optional.default(nil)
      attribute :area_resource_count      , Types::Strict::Integer.optional.default(nil)
      attribute :area_document_count      , Types::Strict::Integer.optional.default(nil)
      attribute :id                       , Types::Strict::Integer
      attribute :key                      , Types::Strict::String
      attribute :namespace                , Types::Strict::String | Types::Strict::Array.of(Types::Strict::String).optional.default(nil)
      attribute :status                   , Types::Strict::String | Types::Strict::Symbol
      attribute :content_type             , Types::Strict::String | Types::Strict::Symbol
      attribute :content                  , Types::Strict::String.optional.default(nil)
      attribute :document_count           , Types::Strict::Integer
      attribute :errors                   , Types::Strict::Array.of(KManager::Overview::Error).optional.default(nil)
      attribute :valid?                   , Types::Strict::Bool
      attribute :scheme                   , Types::Strict::String | Types::Strict::Symbol
      attribute :path                     , Types::Strict::String
      attribute :relative_path            , Types::Strict::String
      attribute :exist?                   , Types::Strict::Bool
    end

    class Document < Dry::Struct
      attribute :area_name                , Types::Strict::String.optional.default(nil) | Types::Strict::Symbol.optional.default(nil)
      attribute :area_namespace           , Types::Strict::String.optional.default(nil) | Types::Strict::Symbol.optional.default(nil)
      attribute :area_resource_count      , Types::Strict::Integer.optional.default(nil)
      attribute :area_document_count      , Types::Strict::Integer.optional.default(nil)
      attribute :resource_id              , Types::Strict::Integer.optional.default(nil)
      attribute :resource_key             , Types::Strict::String
      attribute :resource_namespace       , Types::Strict::Array.of(Types::Strict::String).optional.default(nil)
      attribute :resource_status          , Types::Strict::String | Types::Strict::Symbol
      attribute :resource_content_type    , Types::Strict::String | Types::Strict::Symbol
      attribute :resource_content         , Types::Strict::String.optional.default(nil)
      attribute :resource_document_count  , Types::Strict::Integer
      attribute :resource_errors          , Types::Strict::Array.of(KManager::Overview::Error).optional.default(nil)
      attribute :resource_valid?          , Types::Strict::Bool
      attribute :resource_scheme          , Types::Strict::String | Types::Strict::Symbol
      attribute :resource_path            , Types::Strict::String
      attribute :resource_relative_path   , Types::Strict::String
      attribute :resource_exist?          , Types::Strict::Bool
      attribute :document_id              , Types::Strict::Integer
      attribute :document_data            , Types::Strict::Hash.optional.default(nil) | Types::Strict::Array.of(Types::Strict::Hash).optional.default(nil)
      attribute :document_key             , Types::Strict::String | Types::Strict::Symbol
      attribute :document_namespace       , Types::Strict::String | Types::Strict::Array.of(Types::Strict::String).optional.default(nil)
      attribute :document_tag             , Types::Strict::String | Types::Strict::Symbol
      attribute :document_type            , Types::Strict::String | Types::Strict::Symbol
      # TODO: Write code to populate this with the resource line number
      attribute :document_location        , Types::Strict::Integer.optional.default(nil)
      attribute :document_errors          , Types::Strict::Array.of(KManager::Overview::Error).optional.default(nil)
      attribute :document_valid?          , Types::Strict::Bool
    end
  end
end
