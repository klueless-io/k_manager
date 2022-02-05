# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Simple Scenario' do
  it 'workflow' do
    KConfig.configure(:traveling_people_spec) do |config|
      path = Dir.pwd
      config.target_folders.add(:app, File.join(path, '.output'))
      config.template_folders.add(:global , File.join(path, '.global_template'))
      config.template_folders.add(:app , File.join(path, '.app_template'))
    end

    area = KManager.add_area(:traveling_people, namespace: :tp)

    resource_manager = area.resource_manager
    resource_manager.add_resource_expand_path('spec/k_manager/scenarios/simple/countries.csv')
    resource_manager.add_resource_expand_path('spec/k_manager/scenarios/simple/traveling-people.json')
    resource_manager.add_resource_expand_path('spec/k_manager/scenarios/simple/ben-dover.jason', content_type: :json) # provide content type when it cannot be inferred
    # resource_manager.load_content
    # resource_manager.register_documents

    # KManager.debug(:resources) # (:config, :resources)

    # KManager.dashboard
  end
end
<<~BASH
  ----------------------------------------------------------------------
  Project k_fileset
  ----------------------------------------------------------------------
  Resource Path (DSL's, Data)   : ~/dev/kgems/k_dsl/_projects/kgems/k_fileset
  Base Path                     : ~/dev/kgems/k_dsl/_
  Cache Data Path               : ~/dev/kgems/k_dsl/_/.cache
  Definition Path               : ~/dev/kgems/k_dsl/_/.definition
  Template Path (Global)        : ~/dev/kgems/k_dsl/_/.template
  Template Path (Application)   : ~/dev/kgems/k_dsl/_projects/kgems/k_fileset/.templates
  ----------------------------------------------------------------------
  Watch these paths and patterns
  ----------------------------------------------------------------------
  **/*.rb
  ----------------------------------------------------------------------
  List of resources
  ----------------------------------------------------------------------
  OBJECT_ID | STATUS | SOURCE | R-TYPE | CONTENT                                                                                              | ERROR | RESOURCE PATH                               | WATCH PATH    | FILENAME
  ----------|--------|--------|--------|------------------------------------------------------------------------------------------------------|-------|---------------------------------------------|---------------|---------------------------------------------------------------------------------------------------------------------------------------------
  6640      | loaded | file   | dsl    | # ------------------------------------------------------------ # MicroApp: Ruby GEM # -----------... |       | ~/dev/kgems/k_dsl/_projects/kgems/k_fileset |               | app.rb
  6660      | loaded | file   | dsl    | KDsl.blueprint :bootstrap_bin_hook do   settings do     name                parent.key     type  ... |       | ~/dev/kgems/k_dsl/_projects/kgems/k_fileset |               | bootstrap_01_bin_hook.rb
  6680      | loaded | file   | dsl    | KDsl.blueprint :bootstrap_upgrade do   settings do     name                parent.key     type   ... |       | ~/dev/kgems/k_dsl/_projects/kgems/k_fileset |               | bootstrap_02_upgrade.rb
  6700      | loaded | file   | dsl    | KDsl.blueprint :bootstrap_github_actions do   settings do     name                parent.key     ... |       | ~/dev/kgems/k_dsl/_projects/kgems/k_fileset |               | bootstrap_03_github_actions.rb
  6720      | loaded | file   | dsl    | # Backlog of items to be addressed # ------------------------------------------------------------... |       | ~/dev/kgems/k_dsl/_projects/kgems/k_fileset | /requirements | backlog.rb
  6740      | loaded | file   | dsl    | # Build README.MD # ------------------------------------------------------------  KDsl.blueprint ... |       | ~/dev/kgems/k_dsl/_projects/kgems/k_fileset | /requirements | readme.rb
  6760      | loaded | file   | dsl    | # Track user-stories and tasks (in progress and done) # -----------------------------------------... |       | ~/dev/kgems/k_dsl/_projects/kgems/k_fileset | /requirements | stories.rb
  6780      | loaded | file   | dsl    | # Examples on how to use for inclusion into USAGE.MD # ------------------------------------------... |       | ~/dev/kgems/k_dsl/_projects/kgems/k_fileset | /requirements | usage.rb
  ----------------------------------------------------------------------
  List of documents
  ----------------------------------------------------------------------
  OBJECT_ID | RESOURCE_ID | DOCUMENT_ID | STATUS | STATE  | NAMESPACE | KEY                      | TYPE      | SOURCE | R-TYPE | DATA                                     | ERROR | RESOURCE PATH                               | WATCH PATH    | FILENAME
  ----------|-------------|-------------|--------|--------|-----------|--------------------------|-----------|--------|--------|------------------------------------------|-------|---------------------------------------------|---------------|---------------------------------------------------------------------------------------------------------------------------------------------
  6800      | 6660        | 6820        | loaded | loaded |           | bootstrap_bin_hook       | blueprint | file   | dsl    | {"settings"=>{"name"=>:bootstrap_bin_... |       | ~/dev/kgems/k_dsl/_projects/kgems/k_fileset |               | bootstrap_01_bin_hook.rb
  6840      | 6700        | 6860        | loaded | loaded |           | bootstrap_github_actions | blueprint | file   | dsl    | {"settings"=>{"name"=>:bootstrap_gith... |       | ~/dev/kgems/k_dsl/_projects/kgems/k_fileset |               | bootstrap_03_github_actions.rb
  6880      | 6680        | 6900        | loaded | loaded |           | bootstrap_upgrade        | blueprint | file   | dsl    | {"settings"=>{"name"=>:bootstrap_upgr... |       | ~/dev/kgems/k_dsl/_projects/kgems/k_fileset |               | bootstrap_02_upgrade.rb
  6920      | 6740        | 6940        | loaded | loaded |           | readme                   | blueprint | file   | dsl    | {"settings"=>{"template_rel_path"=>"r... |       | ~/dev/kgems/k_dsl/_projects/kgems/k_fileset | /requirements | readme.rb
  6960      | 6720        | 6980        | loaded | loaded |           | backlog                  | entity    | file   | dsl    | {"backlog"=>{"fields"=>[{"name"=>"typ... |       | ~/dev/kgems/k_dsl/_projects/kgems/k_fileset | /requirements | backlog.rb
  7000      | 6760        | 7020        | loaded | loaded |           | stories                  | entity    | file   | dsl    | {"stories"=>{"fields"=>[{"name"=>"typ... |       | ~/dev/kgems/k_dsl/_projects/kgems/k_fileset | /requirements | stories.rb
  7040      | 6780        | 7060        | loaded | loaded |           | usage                    | entity    | file   | dsl    | {"example_groups"=>{"fields"=>[{"name... |       | ~/dev/kgems/k_dsl/_projects/kgems/k_fileset | /requirements | usage.rb
  7080      | 6640        | 7100        | loaded | loaded |           | k_fileset                | microapp  | file   | dsl    | {"settings"=>{"ruby_version"=>"2.7.2"... |       | ~/dev/kgems/k_dsl/_projects/kgems/k_fileset |               | app.rb
  ======================================================================
  Project manager is watching resources for projects
  ======================================================================
  quick_commands                : /Users/davidcruwys/dev/kgems/k_dsl/_projects/cmd
  k_fileset                     : /Users/davidcruwys/dev/kgems/k_dsl/_projects/kgems/k_fileset
  k_fileset                     : /Users/davidcruwys/dev/kgems/k_dsl/_projects/kgems/k_fileset/requirements
BASH
