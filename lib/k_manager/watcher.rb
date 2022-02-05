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

    # rubocop:disable Lint/RescueException, Metrics/AbcSize, Metrics/MethodLength
    def start
      boot_up

      update_dashboard

      watcher = Filewatcher.new(watch_folder)

      watcher.watch do |changes|
        watcher.pause
        if changes.length > 1
          log.kv 'HOW MANY CHANGES', changes.length
          log.block changes
        end

        changes.each do |filename, event|
          # NOTE: KManager will not support space in file name, but this will at least deal with file copies, where " copy" is added to a file name.
          filename = filename.gsub(' ', '%20')

          log_file_event(event, filename)

          uri = URI::File.build(host: nil, path: filename)

          start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
          KManager.resource_changed(uri, event)
          finish_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
          time_taken = finish_time - start_time

          sleep KManager.opts.sleep if KManager.opts.sleep.positive?

          clear_screen

          log_file_event(event, filename)
          log.kv 'Time Taken', time_taken.to_d.round(3, :truncate).to_f if KManager.opts.show.time_taken

          update_dashboard

          puts KManager.opts.show.finished_message if KManager.opts.show.finished
        end
        watcher.resume
      end
    rescue Interrupt, SystemExit
      raise
    rescue Exception => e
      log.exception(e)
    end
    # rubocop:enable Lint/RescueException, Metrics/AbcSize, Metrics/MethodLength

    private

    def log_file_event(event, filename)
      current = Time.now.strftime('%H:%M:%S')
      output = "#{current} - #{event}: #{filename}"

      log.warn(output)  if event == :updated
      log.error(output) if event == :deleted
      log.info(output)  if event == :created
    end

    def boot_up
      clear_screen

      if File.exist?(boot_file)
        content = File.read(boot_file)
        Object.class_eval(content, boot_file)
        return
      end

      log.error("Boot file not found: #{boot_file}")
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
