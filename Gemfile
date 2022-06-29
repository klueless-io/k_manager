# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in handlebars_helpers.gemspec
gemspec

# group :development do
#   # Currently conflicts with GitHub actions and so I remove it on push
#   # pry on steroids
#   gem 'jazz_fingers'
#   gem 'pry-coolline', github: 'owst/pry-coolline', branch: 'support_new_pry_config_api'
# end

group :development, :test do
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'rake'
  gem 'rake-compiler', require: false
  gem 'rspec', '~> 3.0'
  gem 'rubocop'
  gem 'rubocop-rake', require: false
  gem 'rubocop-rspec', require: false
end

# If local dependency
if ENV['KLUE_LOCAL_GEMS']&.to_s&.downcase == 'true'
  group :development, :test do
    puts 'Using Local GEMs'
    gem 'handlebars-helpers'      , path: '../handlebars-helpers'
    gem 'k_builder'               , path: '../k_builder'
    gem 'k_builder-dotnet'        , path: '../k_builder-dotnet'
    # gem 'k_builder-package_json'  , path: '../k_builder-package_json'
    gem 'drawio_dsl'              , path: '../drawio_dsl'
    gem 'k_builder-webpack5'      , path: '../k_builder-webpack5'
    gem 'k_config'                , path: '../k_config'
    gem 'k_decor'                 , path: '../k_decor'
    gem 'k_director'              , path: '../k_director'
    gem 'k_doc'                   , path: '../k_doc'
    gem 'k_domain'                , path: '../k_domain'
    gem 'k_ext-github'            , path: '../k_ext-github'
    gem 'k_fileset'               , path: '../k_fileset'
    gem 'k_log'                   , path: '../k_log'
    gem 'k_type'                  , path: '../k_type'
    gem 'k_util'                  , path: '../k_util'
    gem 'peeky'                   , path: '../peeky'
  end
end
