# frozen_string_literal: true

include KLog::Logging

# TODO: I need a memory profiling tool to see if I am releasing memory correctly with the .reset
log.warn "Startup Folder: #{Dir.pwd}"

KManager.reset

area = KManager.add_area(:traveling_people, namespace: :tp)

resource_manager = area.resource_manager
resource_manager.add_resource_expand_path('spec/k_manager/scenarios/simple/countries.csv')
resource_manager.add_resource_expand_path('spec/k_manager/scenarios/simple/traveling-people.json')
resource_manager.add_resource_expand_path('spec/k_manager/scenarios/simple/ben-dover.jason', content_type: :json)
resource_manager.add_resource_expand_path('spec/k_manager/scenarios/simple/me.txt')
resource_manager.add_resource_expand_path('spec/k_manager/scenarios/simple/not-found.txt')
resource_manager.add_resource_expand_path('spec/k_manager/scenarios/simple/not-found.rb')
resource_manager.add_resource_expand_path('spec/k_manager/scenarios/simple/query.rb')
resource_manager.add_resource_expand_path('spec/k_manager/scenarios/simple/rich_data.rb')

KManager.fire_actions(:load_content, :register_document, :load_document)

puts 'lets boot it'