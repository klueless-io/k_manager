# frozen_string_literal: true
module KManager
  class PathEntry # < Pathname
    # unique absolute path name (/abc, /abc/.)
    attr_reader :key
    attr_reader :path_name # Pathname 
    attr_reader :pwd
    attr_reader :relative_path

    def initialize(key, path_name, pwd, relative_path)
      # super(relative_path)
      @key = key
      @path_name = path_name
      @pwd = pwd
      @relative_path = relative_path
    end

    # Realpath (is the absolute path of the entry)
    #
    # The Realpath is based on the current directory at the time this entry was created
    def realpath
      path_name.realpath(pwd)
    end
  end
end

# relative_path() if its in two places
