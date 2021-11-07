# frozen_string_literal: true
module KManager
  # FileSet will build up a list of files using Glob patterns.
  #
  # That list of files can be filtered using exclusions that
  # follow either Glob or Regex patterns.
  #
  # Keeping track of excluded patterns is useful in KManager because an existing file may be
  # or a new file added and a file watcher my attempt to process that file. The exclusion patterns
  # provide a way to ignore the file.
  #
  # FileSet uses some code from Rake-FileList, but uses the builder pattern to build up a
  # list of included files and inclusion/exclusion patterns instead of the Array emulation that rake uses.
  #
  # Usage:
  # Assumes that the current directory is /some_path/k_manager
  EXAMPLE = <<-RUBY
  
  # /Dir.glob('(david|sean|lisa)')
  # /Users/davidcruwys/dev/kgems/k_manager
  # .cd('/Users/davidcruwys/dev/kgems/k_manager')


  
  Watcher.process_file(file, event) do
    file = '/Users/davidcruwys/dev/kgems/k_manager/spec/samples/.builder/a/b/c/d/e/bob.png'
    file = '/Users/davidcruwys/dev/kgems/k_manager/spec/samples/.builder/a/b/c/d/e/bob.rb'

    case
    when event :updated
      if file_set.valid?(file)
        continue_processing(file)
      end

    when event :deleted
      file_set.remove(file)
    end
  end

  whitelist = [
    WhiteListEntry.new(
      '/Users/davidcruwys/dev/kgems/k_manager/spec/samples/.builders/**/*',
      [/(sean|david).txt/, /\*.xlsx?/, /\*.(jpe?g|png|gif)/]
    ),
    WhiteListEntry.new(
      '/Users/davidcruwys/dev/kgems/k_manager/spec/.templates/**/*',
      /bob.(jpe?g|png|gif|rb)/
    )
  ]


  file_set = KManager::FileSet.new
    .cd('spec/samples')                               # /Users/davidcruwys/dev/kgems/k_manager/spec/samples
    .add('.builder/**/*')
    .add('.builder/**/*', exclude: '*.txt')           # /Users/davidcruwys/dev/kgems/k_manager/spec/samples/.builders/**/*
    .add('.builder/**/*', exclude: /\.txt/)
    .add('.builder/**/*', exclude: [
      /(sean|david).txt/,
      /\*.xlsx?/,
      /\*.(jpe?g|png|gif)/
    ])
    .add('../.templates/**/*', exclude: /bob.(jpe?g|png|gif|rb)/)   # /Users/davidcruwys/dev/kgems/k_manager/spec/.templates/**/*


  RUBY

  # 
  #
  # Resources:
  #   - Rake-FileList: https://github.dev/ruby/rake/blob/5c60da8644a9e4f655e819252e3b6ca77f42b7af/lib/rake/file_list.rb
  #   - Glob vs Regex: https://www.linuxjournal.com/content/globbing-and-regex-so-similar-so-different
  #   - Glob patterns: http://web.mit.edu/racket_v612/amd64_ubuntu1404/racket/doc/file/glob.html
  #   require 'rake/file_list'
  #   Rake::FileList['**/*'].exclude(*File.read('.gitignore').split)

  class FileSet
    class WhiteListEntry
      attr_reader :glob
      attr_reader :exclusion
      def initialize(glob, exclusion)
        @glob = glob
        @exclusion = exclusion
      end
  
      def match?(file)
        true # if file is glob and not exclusion
      end
    end
  
    # Expression to detect standard file GLOB pattern
    GLOB_PATTERN = %r{[*?\[\{]}

    attr_reader :files
    attr_reader :whitelist

    def initialize
      @files = Set.new
      @whitelist = []
    end

    def add(glob, exclude: nil)
      add_files = exclude_files(glob, exclude)
      @files.merge(add_files)

      self
    end

    def valid?(file)
      return true if files.include?(file)

      if new_file_match?(file)
        @files.add(file)
        return true
      end

      false
    end

    def remove(file)
      @files.delete(file)
    end

    private

    def new_file_match?(file)
      whitelist.any? { |white_entry| white_entry.match?(file) }
    end

    def exclude_files(glob, exclude = nil)
      get_files = Dir[glob]

      return get_files unless exclude
      return get_files.reject { |file| exclude.match?(file) } if exclude.is_a?(Regex)
      # return get_files.reject { |file| exclude.match?(file) } if exclude.is_a?(String)
      return get_files.reject { |file| excludes.any? { |rex| rex.match?(file) } } if exclude.is_a?(Array)

      get_files
    end

    # def match?(file, match_value)
    # end


    # Create a file list from the globbable patterns given.  If you wish to
    # perform multiple includes or excludes at object build time, use the
    # "yield self" pattern.
    #
    # Example:
    #   file_list = FileList.new('lib/**/*.rb', 'test/test*.rb')
    #
    #   pkg_files = FileList.new('lib/**/*') do |fl|
    #     fl.exclude(/\bCVS\b/)
    #   end
    #
    def xinitialize(*patterns)
      @pending_add = []
      @pending = false
      @exclude_patterns = DEFAULT_IGNORE_PATTERNS.dup
      @exclude_procs = DEFAULT_IGNORE_PROCS.dup
      @items = []
      patterns.each { |pattern| include(pattern) }
      yield self if block_given?
    end

    # Add file names defined by glob patterns to the file list.  If an array
    # is given, add each element of the array.
    #
    # Example:
    #   file_list.include("*.java", "*.cfg")
    #   file_list.include %w( math.c lib.h *.o )
    #
    def include(*filenames)
      # TODO: check for pending
      filenames.each do |fn|
        if fn.respond_to? :to_ary
          include(*fn.to_ary)
        else
          @pending_add << from_pathname(fn)
        end
      end
      @pending = true
      self
    end
    # alias :add :include

    # Register a list of file name patterns that should be excluded from the
    # list.  Patterns may be regular expressions, glob patterns or regular
    # strings.  In addition, a block given to exclude will remove entries that
    # return true when given to the block.
    #
    # Note that glob patterns are expanded against the file system. If a file
    # is explicitly added to a file list, but does not exist in the file
    # system, then an glob pattern in the exclude list will not exclude the
    # file.
    #
    # Examples:
    #   FileList['a.c', 'b.c'].exclude("a.c") => ['b.c']
    #   FileList['a.c', 'b.c'].exclude(/^a/)  => ['b.c']
    #
    # If "a.c" is a file, then ...
    #   FileList['a.c', 'b.c'].exclude("a.*") => ['b.c']
    #
    # If "a.c" is not a file, then ...
    #   FileList['a.c', 'b.c'].exclude("a.*") => ['a.c', 'b.c']
    #
    def exclude(*patterns, &block)
      patterns.each do |pat|
        if pat.respond_to? :to_ary
          exclude(*pat.to_ary)
        else
          @exclude_patterns << from_pathname(pat)
        end
      end
      @exclude_procs << block if block_given?
      resolve_exclude unless @pending
      self
    end

    # Clear all the exclude patterns so that we exclude nothing.
    def clear_exclude
      @exclude_patterns = []
      @exclude_procs = []
      self
    end

    # Convert Pathname and Pathname-like objects to strings;
    # leave everything else alone
    def from_pathname(path)    # :nodoc:
      path = path.to_path if path.respond_to?(:to_path)
      path = path.to_str if path.respond_to?(:to_str)
      path
    end

    # A FileList is equal through array equality.
    def ==(array)
      to_ary == array
    end

    # Return the internal array object.
    def to_a
      resolve
      @items
    end

    # Return the internal array object.
    def to_ary
      to_a
    end

    # Lie about our class.
    def is_a?(klass)
      klass == Array || super(klass)
    end
    alias kind_of? is_a?

    # Redefine * to return either a string or a new file list.
    def *(other)
      result = @items * other
      case result
      when Array
        self.class.new.import(result)
      else
        result
      end
    end

    def <<(obj)
      resolve
      @items << from_pathname(obj)
      self
    end

    # Resolve all the pending adds now.
    def resolve
      if @pending
        @pending = false
        @pending_add.each do |fn| resolve_add(fn) end
        @pending_add = []
        resolve_exclude
      end
      self
    end

    def resolve_add(fn) # :nodoc:
      case fn
      when GLOB_PATTERN
        add_matching(fn)
      else
        self << fn
      end
    end
    private :resolve_add

    def resolve_exclude # :nodoc:
      reject! { |fn| excluded_from_list?(fn) }
      self
    end
    private :resolve_exclude

    # Return a new FileList with the results of running +sub+ against each
    # element of the original list.
    #
    # Example:
    #   FileList['a.c', 'b.c'].sub(/\.c$/, '.o')  => ['a.o', 'b.o']
    #
    def sub(pat, rep)
      inject(self.class.new) { |res, fn| res << fn.sub(pat, rep) }
    end

    # Return a new FileList with the results of running +gsub+ against each
    # element of the original list.
    #
    # Example:
    #   FileList['lib/test/file', 'x/y'].gsub(/\//, "\\")
    #      => ['lib\\test\\file', 'x\\y']
    #
    def gsub(pat, rep)
      inject(self.class.new) { |res, fn| res << fn.gsub(pat, rep) }
    end

    # Same as +sub+ except that the original file list is modified.
    def sub!(pat, rep)
      each_with_index { |fn, i| self[i] = fn.sub(pat, rep) }
      self
    end

    # Same as +gsub+ except that the original file list is modified.
    def gsub!(pat, rep)
      each_with_index { |fn, i| self[i] = fn.gsub(pat, rep) }
      self
    end

    # Apply the pathmap spec to each of the included file names, returning a
    # new file list with the modified paths.  (See String#pathmap for
    # details.)
    def pathmap(spec=nil, &block)
      collect { |fn| fn.pathmap(spec, &block) }
    end

    # Return a new FileList with <tt>String#ext</tt> method applied to
    # each member of the array.
    #
    # This method is a shortcut for:
    #
    #    array.collect { |item| item.ext(newext) }
    #
    # +ext+ is a user added method for the Array class.
    def ext(newext="")
      collect { |fn| fn.ext(newext) }
    end

    # Grep each of the files in the filelist using the given pattern. If a
    # block is given, call the block on each matching line, passing the file
    # name, line number, and the matching line of text.  If no block is given,
    # a standard emacs style file:linenumber:line message will be printed to
    # standard out.  Returns the number of matched items.
    def egrep(pattern, *options)
      matched = 0
      each do |fn|
        begin
          File.open(fn, "r", *options) do |inf|
            count = 0
            inf.each do |line|
              count += 1
              if pattern.match(line)
                matched += 1
                if block_given?
                  yield fn, count, line
                else
                  puts "#{fn}:#{count}:#{line}"
                end
              end
            end
          end
        rescue StandardError => ex
          $stderr.puts "Error while processing '#{fn}': #{ex}"
        end
      end
      matched
    end

    # Return a new file list that only contains file names from the current
    # file list that exist on the file system.
    def existing
      select { |fn| File.exist?(fn) }.uniq
    end

    # Modify the current file list so that it contains only file name that
    # exist on the file system.
    def existing!
      resolve
      @items = @items.select { |fn| File.exist?(fn) }.uniq
      self
    end

    # FileList version of partition.  Needed because the nested arrays should
    # be FileLists in this version.
    def partition(&block)       # :nodoc:
      resolve
      result = @items.partition(&block)
      [
        self.class.new.import(result[0]),
        self.class.new.import(result[1]),
      ]
    end

    # Convert a FileList to a string by joining all elements with a space.
    def to_s
      resolve
      self.join(" ")
    end

    # Add matching glob patterns.
    def add_matching(pattern)
      self.class.glob(pattern).each do |fn|
        self << fn unless excluded_from_list?(fn)
      end
    end
    private :add_matching

    # Should the given file name be excluded from the list?
    #
    # NOTE: This method was formerly named "exclude?", but Rails
    # introduced an exclude? method as an array method and setup a
    # conflict with file list. We renamed the method to avoid
    # confusion. If you were using "FileList#exclude?" in your user
    # code, you will need to update.
    def excluded_from_list?(fn)
      return true if @exclude_patterns.any? do |pat|
        case pat
        when Regexp
          fn =~ pat
        when GLOB_PATTERN
          flags = File::FNM_PATHNAME
          # Ruby <= 1.9.3 does not support File::FNM_EXTGLOB
          flags |= File::FNM_EXTGLOB if defined? File::FNM_EXTGLOB
          File.fnmatch?(pat, fn, flags)
        else
          fn == pat
        end
      end
      @exclude_procs.any? { |p| p.call(fn) }
    end

    DEFAULT_IGNORE_PATTERNS = [
      /(^|[\/\\])CVS([\/\\]|$)/,
      /(^|[\/\\])\.svn([\/\\]|$)/,
      /\.bak$/,
      /~$/
    ]
    DEFAULT_IGNORE_PROCS = [
      proc { |fn| fn =~ /(^|[\/\\])core$/ && !File.directory?(fn) }
    ]

    def import(array) # :nodoc:
      @items = array
      self
    end

    class << self
      # Create a new file list including the files listed. Similar to:
      #
      #   FileList.new(*args)
      def [](*args)
        new(*args)
      end

      # Get a sorted list of files matching the pattern. This method
      # should be preferred to Dir[pattern] and Dir.glob(pattern) because
      # the files returned are guaranteed to be sorted.
      def glob(pattern, *args)
        Dir.glob(pattern, *args).sort
      end
    end
  end
end
