# frozen_string_literal: true

module KManager
  module Resources
    require 'handlebars/helpers/string_formatting/dasherize'

    # A memory resource represents content that is generated programmatically and just stored in memory.
    class MemResource < KManager::Resources::BaseResource
    end
  end
end
