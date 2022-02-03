# frozen_string_literal: true

require 'pry'
require 'k_manager'
# require 'filewatcher'
# require 'io/console'

namespace :k_manager do
  desc 'Watch '
  task :watch do
    target_folder = 'spec/k_manager/scenarios'
    watch_folder = File.join(Dir.pwd, target_folder)
    boot_file = File.join(watch_folder, 'simple/boot.rb')

    watcher = Watcher.new(watch_folder, boot_file)
    watcher.start
  end
end
