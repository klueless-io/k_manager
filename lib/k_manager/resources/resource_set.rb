# frozen_string_literal: true

module KManager
  # A resource set holds a list of resources
  #
  # A resource could be a file, web-service, gist, ftp endpoint, memory object.
  # The only supported resource types so far are:
  #  - File
  #
  # Resources can be registered with the ResourceSet using register_* methods
  # 
  # somepath
  # somepath/my_dsls
  # somepath/my_dsls/path1
  # somepath/my_dsls/path2
  # somepath/my_dsls/path2/child
  # somepath/my_dsls/path2/old        (skip this path)
  # somepath/my_data/
  # somepath/my_templates
  class ResourceSet

    attr_reader :uri_set

    def initialize
      @uri_list = []
      @file_list = []
    end

    # Attach file based URI's
    #
    # @param [String] path Base path where files are found, defaults Dir.pwd
    # @param [Array] include Include file patterns
    # @param [Array] exclude Exclude file patterns
    def attach_files(*patterns, exclude: nil)
      files = FileList.new(*patterns).exclude(exclude)
      files.exclude(*exclude) if exclude && exclude.is_a?(Array)
      files.exclude(exclude) if exclude && !exclude.is_a?(Array)
      @file_list += files
      @file_list.uniq!
      @file_list
    end

    # def attach_files(*patterns, excludes: [], )
    #   FileList.new(*patterns).exclude(*excludes)
    #   binding.pry
    # end

    # def find_files(*paths, exclude: [])
    # end

    # def add_files(*files)
    #   @files_list += files
    # end

    private

    def file_list
    end

  end
end
