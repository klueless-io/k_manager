# frozen_string_literal: true

module KManager
  class GlobInfo # GlobConfig, GlobBuilder
    include GlobProps

    def initialize(glob, exclude = nil, flags = File::FNM_PATHNAME | File::FNM_EXTGLOB)
      @working_directory = Dir.pwd
      @glob = Pathname.new(glob).cleanpath.to_s
      @glob += File::SEPARATOR if glob.ends_with?(File::SEPARATOR)
      @flags = flags

      # absolute_path_glob
      @exclusions = build_exclusions(exclude)
    end

    def entry
      GlobEntry.new(working_directory, glob, flags, exclusions)
    end

    class << self
      def build_glob_entries(glob_infos)
        glob_entries = []
      
        glob_infos.each do |glob_info|
          found = glob_entries.find_index { |entry| entry.working_directory == glob_info.working_directory && entry.glob == glob_info.glob }
  
          if found
            glob_entries[found].exclusions = (glob_entries[found].exclusions + glob_info.exclusions).uniq
          else
            glob_entries << GlobEntry.new(glob_info.working_directory, glob_info.glob, glob_info.flags, glob_info.exclusions)
          end
        end
        glob_entries
      end
    end

    private

    # Handles String based Glob, Regexp pattern or lambda expression
    def build_exclusions(exclude)
      return [] if exclude.nil?
      return [exclude] if exclude.is_a?(String) || exclude.is_a?(Regexp) || exclude.respond_to?(:call)
      exclude.select { |ex| ex.is_a?(String) || ex.is_a?(Regexp) || ex.respond_to?(:call) }
    end
  end
end
