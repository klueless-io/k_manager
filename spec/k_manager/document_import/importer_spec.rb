# frozen_string_literal: true

KConfig.configure(:traveling_people_spec) do |config|
  path = Dir.pwd
  config.target_folders.add(:app, File.join(path, '.output'))
  config.template_folders.add(:global , File.join(path, '.global_template'))
  config.template_folders.add(:app , File.join(path, '.app_template'))
end

RSpec.describe KManager::DocumentImport::Importer do
  subject { instance }

  let(:instance) { described_class.new(key: key, **opts) }
  let(:key) { :xmen }
  let(:opts) { {} }

  context 'setup workflow' do
    # before do
    #   area1 = KManager.add_area(:xmen)
    #   resource_manager1 = area1.resource_manager
    #   resource_manager1.add_resource_expand_path('spec/samples/.builder/data_files/ruby-import-dsl.rb')

    #   area2 = KManager.add_area(:thunderbirds, namespace: :are_go)
    #   resource_manager2 = area2.resource_manager
    #   resource_manager2.add_resource_expand_path('spec/samples/.builder/data_files/ruby-import-dsl.rb')

    #   KManager.fire_actions(:load_content, :register_document, :load_document)
    # end

    # fit 'should display dashboard' do
    #   dashboard = KManager::Overview::Dashboard.new(KManager.manager)
    #   # dashboard.areas
    #   # dashboard.resources
    #   dashboard.documents
    # end
  end
end
