# frozen_string_literal: true

module KManager
  module Documents
    class SimpleDocument
      include KLog::Logging
      include KManager::Documents::DocumentTags
    end
  end
end
