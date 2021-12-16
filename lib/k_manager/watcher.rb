# frozen_string_literal: true

require 'filewatcher'
require 'io/console'

module KManager
  # NOTE: Does Watcher belong in this GEM?
  class Watcher
    include KLog::Logging
  
    attr_reader :watch_folder
    attr_reader :boot_file
  
    def initialize(watch_folder, boot_file)
      @watch_folder = watch_folder
      @boot_file = boot_file
    end

    # process_created_file(filename) if event == :created
    # process_updated_file(filename) if event == :updated # || event == :created
    # process_deleted_file(filename) if event == :deleted

    # rubocop:disable Lint/RescueException
    def start
      bootup

      update_dashboard

      Filewatcher.new(watch_folder).watch do |changes|
        changes.each do |filename, event|
          clear_screen

          puts "File #{event}: #{filename}"
  
          uri = URI::File.build(host: nil, path: filename)
          KManager.resource_changed(uri, event)
  
          update_dashboard
        end
      end
    rescue Exception => e
      # TODO: Make style a setting: :message, :short, (whatever the last one is)
      log.exception(e, style: :short)
    end
    # rubocop:enable Lint/RescueException
  
    private
  
    def bootup
      clear_screen
  
      content = File.read(boot_file)
      Object.class_eval(content, boot_file)
    end
  
    def update_dashboard
      dashboard = KManager::Overview::Dashboard.new(KManager.manager)
      # dashboard.areas
      dashboard.resources
      dashboard.documents
    end
  
    def update_load_path(filename)
      dirname = File.dirname(filename)
  
      # This needs to be in detailed logging
      $LOAD_PATH.unshift(dirname) unless $LOAD_PATH.find { |path| path.start_with?(dirname) }
    end
  
    def clear_screen
      puts "\n" * 70
      $stdout.clear_screen
    end
  end
end
