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

resource_manager.add_resource('https://gist.githubusercontent.com/klueless-io/36a53ac9683866d923ce9fa99ccca436/raw/people.csv', content_type: :csv)
resource_manager.add_resource('https://gist.githubusercontent.com/klueless-io/32397b82f2ba607ce3dc452dcb357a99/raw/site_definition.rb', content_type: :ruby)
resource_manager.add_resource('https://gist.githubusercontent.com/klueless-io/0140db92d83714caba370fc311973068/raw/string_color.rb', content_type: :ruby)

KManager.fire_actions(:load_content, :register_document, :load_document)

puts 'lets boot it'
