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

# Useful Pathname methods
#
# p.directory?
# p.root?
# p.absolute?
# p.relative?
# p.exist?
# p.file?
# p.size?
# p.zero?
# p.ftype
# p.empty?
# p.each_line
# p.read
# p.readlines

# p.readable?
# p.birthtime

# p.join
# p.mkpath
# p.find
# p.entries
# p.stat
# p.each_entry
# p.relative_path_from

# p.expand_path
# p.realdirpath
# p.realpath
# p.extname
# p.basename
# p.dirname
# p.relative_path_from
# p.to_path
# p.parent
# p.split
# p.size
# p.cleanpath
# p.children
# p.mkdir
# p.rmdir
# p.glob
# p.fnmatch
# p.fnmatch?
# p.delete
# p.each_filename
# p.each_line

# p.read
# p.readlines