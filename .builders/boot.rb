# Boot Sequence

include KLog::Logging

CONFIG_KEY = :k_manager

log.kv 'working folder', Dir.pwd

KConfig.configure do |config|
  config.handlebars.defaults.add_array_defaults
  config.handlebars.defaults.add_case_defaults
  config.handlebars.defaults.add_comparison_defaults
  config.handlebars.defaults.add_inflection_defaults
end

# def camel
#   Cmdlet::Case::Camel.new
# end
# def titleize
#   Cmdlet::Case::Title.new
# end
# def pluralize
#   Cmdlet::Case::Pluralize.new
# end
# def singularize
#   Cmdlet::Case::Singularize.new
# end
# def dasherize
#   Cmdlet::Case::Dash.new
# end

def k_builder
  @k_builder ||= KBuilder::BaseBuilder.init(KConfig.configuration(CONFIG_KEY))
end

KConfig.configure(CONFIG_KEY) do |config|
  builder_folder    = Dir.pwd
  base_folder       = File.expand_path('../', builder_folder)
  global_template   = File.expand_path('~/dev/kgems/k_templates/templates')

  config.template_folders.add(:global_template    , global_template)
  config.template_folders.add(:template           , File.expand_path('.templates', Dir.pwd))

  config.target_folders.add(:app                  , base_folder)
  config.target_folders.add(:builder              , builder_folder)
  config.target_folders.add(:graph                , builder_folder, 'graph')
end

KConfig.configuration(CONFIG_KEY).debug

area = KManager.add_area(CONFIG_KEY)
resource_manager = area.resource_manager
resource_manager
  .fileset
  .glob('*.rb', exclude: ['boot.rb'])
  .glob('generators/**/*.rb')
resource_manager.add_resources

KManager.boot
