# frozen_string_literal: true

# Setup is just some procedural code for execution
include KLog::Logging

log.error KManager.current_resource.area.name
log.warn 'david'
log.warn 'was'
log.warn 'here'

KManager.current_resource.debug
# country_container = KManager.find_resource(:countries_csv)

# ADD Current Area to the Debug
