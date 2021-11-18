# frozen_string_literal: true

module KManager
  class PathEntry < Pathname
    include KLog::Logging
    # unique absolute path name e.g.(/abc, /abc/.)
    # attr_reader :key
    # attr_reader :path_name # Pathname 
    attr_reader :working_directory
    # attr_reader :relative_path

    def initialize(path) # _path_name, 
      super(path)
      # binding.pry
      # @key = realpath.to_s
      # @key = File.join(@key, '.') if pathname.ends_with?('.')
      # puts @key
      # @path_name = path_name
      @working_directory = Dir.getwd
      # @pathname = pathname
      # debug
    end

    def key
      return @key if defined? @key
      @key = begin
        key = realpath.to_s
        key = File.join(key, '.') if basename.to_s == '.' # if pathname.ends_with?('.')
        key
      end      
    end

    # Realpath (is the absolute path of the entry)
    #
    # The Realpath is based on the current directory at the time this entry was created
    # def realpath
    #   path_name.realpath(working_directory).to_s
    # end

    def path
      self.realpath.to_s
    end

    def debug
      # puts "expand_path   : #{self.expand_path.to_s}"
      # puts "realdirpath   : #{self.realdirpath.to_s}"
      # puts "realpath      : #{self.realpath.to_s}"
      # puts "extname       : #{self.extname.to_s}"
      # puts "basename      : #{self.basename.to_s}"
      # puts "dirname       : #{self.dirname.to_s}"
      # puts "to_path       : #{self.to_path.to_s}"
      # puts "parent        : #{self.parent.to_s}"
      # binding.pry
      # log.line
      log.kv 'key', key
      log.kv 'working_directory', working_directory
      log.kv 'pathname', path

      log.kv 'to_path', to_path
      log.kv 'cleanpath', cleanpath

      # log.kv 'directory?', directory?
      # log.kv 'root?', root?
      # log.kv 'absolute?', absolute?
      # log.kv 'relative?', relative?
      # log.kv 'exist?', exist?
      # log.kv 'file?', file?
      # log.kv 'size?', size?
      # log.kv 'ftype', ftype
      # log.kv 'empty?', empty?
      # log.kv 'readable?', readable?
      # log.kv 'birthtime', birthtime
      # log.kv 'expand_path', expand_path
      # log.kv 'realdirpath', realdirpath
      # log.kv 'realpath', realpath
      # log.kv 'extname', extname
      # log.kv 'basename', basename
      # log.kv 'dirname', dirname
      # log.kv 'to_path', to_path
      # log.kv 'size', size
      
      log.line
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