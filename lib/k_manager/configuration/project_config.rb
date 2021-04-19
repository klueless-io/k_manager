# frozen_string_literal: true

module KManager
  module Configuration
    # Project configuration class for KManager
    #
    # This configuration contains template and target folders as used
    # by all k_builders, it also has additional configuration that makes
    # sense for a project, such as the GitHub repository configuration
    class ProjectConfig < KBuilder::Configuration
      attach_to(KExt::Github::Configuration, self, :github)
    end
  end
end
