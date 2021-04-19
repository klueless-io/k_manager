# frozen_string_literal: true

module KManager
  module Configuration
    # Project configuration class for KManager
    #
    # This configuration contains template and target folders as used
    # by all k_builders, it also has additional configuration that makes
    # sense for a project, such as the GitHub repository configuration
    class Project < KBuilder::Configuration
      attach_to(KExt::Github::Configuration, KManager::Configuration::Project, :github)

      # attr_accessor :package_groups

      # def initialize
      #   super()
      # end
    end
  end
end
