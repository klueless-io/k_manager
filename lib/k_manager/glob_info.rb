# frozen_string_literal: true
module KManager
  class GlobInfo

    attr_reader :path
    attr_reader :glob
    attr_reader :flags
    attr_reader :exclusions

    def initialize(glob, exclude = nil, flags = File::FNM_PATHNAME | File::FNM_EXTGLOB)
      @path = Dir.pwd
      @glob = Pathname.new(glob).cleanpath.to_s
      @glob += File::SEPARATOR if glob.ends_with?(File::SEPARATOR)
      @flags = flags

      # absolute_path_glob
      @exclusions = build_exclusions(exclude)
    end

    def entry
      entry = GlobEntry.new
      entry.path = self.path
      entry.glob = self.glob
      entry.flags = self.flags
      entry.exclusions = self.exclusions
      entry
    end

    private

    # Handles String based Glob, Regexp pattern or lambda expression
    def build_exclusions(exclude)
      return [] if exclude.nil?
      return [exclude] if exclude.is_a?(String) || exclude.is_a?(Regexp) || exclude.respond_to?(:call)
      exclude.select { |ex| ex.is_a?(String) || ex.is_a?(Regexp) || ex.respond_to?(:call) }
    end

    # Flatten (or normalize the path and glob)
    #
    # Move NON glob relative folders to the end of the path
    #
    #
    # example (when current dir is /xmen):
    #
    # original_glob : some_path/**/
    # path:         : /xmen/some_path
    # glob:         : **/
    #
    # original_glob : some_path/*.*
    # path:         : /xmen/some_path
    # glob:         : *.*
    #
    # original_glob : some_path/*
    # path:         : /xmen/some_path
    # glob:         : *
    #
    # original_glob : ../*
    # path:         : /xmen
    # glob:         : *

    # original_glob : spec/k_manager/../../../k_manager/spec/../what_*.tf
    # path:         : /xmen
    # glob:         : what_*.tf


    # original_path will be become path
    # original_glob will be become glob

    # path will be become absolute_path
    # glob will be become absolute_glob

    # def absolute_path_glob
    #   abs_path = [path]
    #   abs_glob = []

    #   glob_parts = Pathname(glob).each_filename.to_a

    #   has_glob = false
    #   glob_parts.each do |part|
    #     if has_glob || GLOB_PATTERN.match?(part)
    #       has_glob = true
    #       abs_glob << part
    #     else
    #       abs_path << part
    #     end
    #   end

    #   abs_glob << File::SEPARATOR if glob.ends_with?(File::SEPARATOR)
    #   @absolute_glob = File.join(abs_glob)
    #   @absolute_path = File.expand_path(File.join(abs_path))
    # end
  end
end
