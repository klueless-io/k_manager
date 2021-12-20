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

# require 'pry'
# require 'k_manager'
# require 'filewatcher'
# require 'io/console'

# class Watcher
#   include KLog::Logging

#   attr_reader :watch_folder
#   attr_reader :boot_file

#   def initialize(watch_folder, boot_file)
#     @watch_folder = watch_folder
#     @boot_file = boot_file
#   end

#
#   def start
#     boot(boot_file)
#     update_dashboard

#     Filewatcher.new(watch_folder).watch do |changes|
#       changes.each do |filename, event|
#         $stdout.clear_screen
#         puts "File #{event}: #{filename}"

#         uri = URI::File.build(host: nil, path: filename)
#         KManager.resource_changed(uri, event)

#         # process_created_file(filename) if event == :created
#         # process_updated_file(filename) if event == :updated # || event == :created
#         # process_deleted_file(filename) if event == :deleted
#         update_dashboard
#       end
#     end
#   rescue Exception => e
#     # TODO: Make style a setting: :message, :short, (whatever the last one is)
#     log.exception(e, style: :short)
#   end
#   #   private

#   def boot(boot_file)
#     clear_screen

#     content = File.read(boot_file)
#     Object.class_eval(content, boot_file)
#   end

#
#   def process_updated_file(filename)
#     clear_screen
#     update_load_path(filename)

#     puts "File updated: #{filename}"
#   rescue Exception => e
#     # TODO: Make style a setting: :message, :short, (whatever the last one is)
#     log.exception(e, style: :short)
#   end

#   def process_updated_file_old(filename)
#     clear_screen
#     update_load_path(filename)

#     puts "File updated: #{filename}"

#     content = File.read(filename)
#     Object.class_eval(content, filename)
#   rescue Exception => e
#     # TODO: Make style a setting: :message, :short, (whatever the last one is)
#     log.exception(e, style: :short)
#   end
#   #   def update_dashboard
#     dashboard = KManager::Overview::Dashboard.new(KManager.manager)
#     dashboard.areas
#     dashboard.resources
#     dashboard.documents
#   end

#   def update_load_path(filename)
#     dirname = File.dirname(filename)

#     # This needs to be in detailed logging
#     $LOAD_PATH.unshift(dirname) unless $LOAD_PATH.find { |path| path.start_with?(dirname) }
#   end

#   def clear_screen
#     puts "\n" * 70
#     $stdout.clear_screen
#   end
# end
