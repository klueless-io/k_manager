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
  # https://github.com/ruby/rake/blob/master/lib/rake/file_list.rb
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
end
