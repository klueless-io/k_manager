# frozen_string_literal: true

# TODO: you cannot run boot while adding resources, you end up with a deadlock
#       need check if configuration is going on and to not accidentally eval additional configuration
# require_relative 'boot'

# Setup is just some procedural code for execution
include KLog::Logging

# log.error KManager.current_resource&.area&.name
log.warn 'david'
# log.warn 'was'
# log.warn 'here'

# KManager.current_resource&.debug
# country_container = KManager.find_resource(:countries_csv)

# ADD Current Area to the Debug
