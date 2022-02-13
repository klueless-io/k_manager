# frozen_string_literal: true

module KManager
  # Allow existing documents from KDoc and other sources to be imported using the resource manager
  module DocumentImport
    class BuildTag
      include KDoc::Taggable

      def initialize(key:, type: :container, namespace: nil)
        opts = {
          key: key,
          type: type,
          namespace: namespace
        }

        initialize_tag(opts)
      end
    end
  end
end
