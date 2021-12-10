# frozen_string_literal: true

namespace :k_manager do
  desc 'Create CSV Files for Models'
  task :watch do
    target_folder = 'spec/k_manager/scenarios'
    watch_folder = File.join(Dir.pwd, target_folder)
    boot_file = File.join(watch_folder, 'simple/boot.rb')

    watcher = Watcher.new(watch_folder, boot_file)
    watcher.start
  end
end

require 'filewatcher'
require 'k_manager'

class Watcher
  include KLog::Logging

  attr_reader :watch_folder
  attr_reader :boot_file

  def initialize(watch_folder, boot_file)
    @watch_folder = watch_folder
    @boot_file = boot_file
  end

  def start
    boot(boot_file)

    Filewatcher.new(watch_folder).watch do |changes|
      changes.each do |filename, event|
        puts "File #{event}: #{filename}"

        # process_created_file(filename) if event == :created
        process_updated_file(filename) if event == :updated # || event == :created
        # process_deleted_file(filename) if event == :deleted
      end
    end
  end

  private

  def boot(boot_file)
    clear_screen

    content = File.read(boot_file)
    Object.class_eval(content, boot_file)
  end

  # rubocop:disable Lint/RescueException
  def process_updated_file(filename)
    clear_screen
    update_load_path(filename)

    puts "File updated: #{filename}"

    content = File.read(filename)
    Object.class_eval(content, filename)
  rescue Exception => e
    # TODO: Make style a setting: :message, :short, (whatever the last one is)
    log.exception(e, style: :short)
  end
  # rubocop:enable Lint/RescueException

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