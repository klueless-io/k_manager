# frozen_string_literal: true
module KManager
  class Whitelist
    def initialize()
      @glob_entries = nil     # glob_entries
      @globs = []             # glob_infos /
    end

    def path_entries
      glob_entries.flat_map { |entry| entry.path_entries }
    end

    def add(glob, exclude = nil, flags = nil)
      flags = FileSet::DEF_FLAGS unless flags
      @glob_entries = nil
      @globs << KManager::GlobInfo.new(glob, exclude, flags)

      self
    end

    def clear
      @glob_entries = nil
      @globs = []

      self
    end
    
    # Return true if file is matched against an entry in the whitelist
    def match?(file)
      glob_entries.any? { |entry| entry.match?(file) }
    end

    # Return GlobInfo entries with the directory, glob and exclusions
    #
    # Will denormalize the entries where matching (path and glob), whilst expanding with any new exclusions.
    def glob_entries
      @glob_entries ||= KManager::GlobInfo.build_glob_entries(@globs)
    end

    # def glob_entries
    #   @glob_entries ||= begin
    #     glob_entries = []
      
    #     @globs.each do |glob|
    #       # found = glob_entries.find_index { |entry| entry.path == glob.absolute_path && entry.glob == glob.absolute_glob }
    #       found = glob_entries.find_index { |entry| entry.path == glob.path && entry.glob == glob.glob }
  
    #       if found
    #         glob_entries[found].exclusions = (glob_entries[found].exclusions + glob.exclusions).uniq
    #       else
    #         glob_entries << glob.entry
    #       end
    #     end
    #     glob_entries
    #   end

    #   @glob_entries
    # end
  end
end
