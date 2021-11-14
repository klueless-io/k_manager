# frozen_string_literal: true
module KManager
  # Rename to Glob
  class GlobEntry
    attr_accessor :path
    attr_accessor :glob
    attr_accessor :exclusions
    attr_accessor :flags

    def path_entries
      # @exclude_procs = DEFAULT_IGNORE_PROCS.dup
      # @exclude_patterns = DEFAULT_IGNORE_PATTERNS.dup

      Dir.chdir(path) do
        Dir.glob(glob, flags)
          .reject { |file| exclusions.any? { |pattern| pattern_match?(pattern, file) } }
          .map do |file|
            pathname = Pathname.new(file)
            key = pathname.realpath.to_s
            key = File.join(key, '.') if file.ends_with?('.')
            PathEntry.new(key, pathname, Dir.pwd, file)
          end
      end
    end

    def match?(absolute_file)
      # match the inclusion Glob first

      # Using absolute files because two sibling Globs may have different exclusion rules
      # and the incoming file needs to be tested against the correct Glob and it's exclusions
      absolute_glob = File.expand_path(glob, path)

      return false unless File.fnmatch?(absolute_glob, absolute_file)

      true
    end

    private

    def pattern_match?(pattern, file)
      return pattern.match?(file) if pattern.is_a?(Regexp)
      return pattern.call(file) if pattern.respond_to?(:call)

      File.fnmatch?(pattern, file) # As String
    end
  end
end


# File.fnmatch('?',   '/', File::FNM_PATHNAME)  #=> false : wildcard doesn't match '/' on FNM_PATHNAME
# File.fnmatch('*',   '/', File::FNM_PATHNAME)  #=> false : ditto
# File.fnmatch('[/]', '/', File::FNM_PATHNAME)  #=> false : ditto
