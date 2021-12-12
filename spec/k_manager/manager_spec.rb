# frozen_string_literal: true

RSpec.describe KManager::Manager do
  include KLog::Logging

  let(:instance) { described_class.new }

  # Workflow needs to move into a different file
  fit 'workflow' do
    KBuilder.configure(:traveling_people_spec) do |config|
      path = Dir.pwd
      config.target_folders.add(:app, File.join(path, '.output'))
      config.template_folders.add(:global , File.join(path, '.global_template'))
      config.template_folders.add(:app , File.join(path, '.app_template'))
    end

    area1 = KManager.add_area(:xmen)
    resource_manager1 = area1.resource_manager
    resource_manager1.add_resource_expand_path('spec/k_manager/scenarios/simple/countries.csv')
    resource_manager1.add_resource_expand_path('spec/k_manager/scenarios/simple/traveling-people.json')

    area2 = KManager.add_area(:traveling_people, namespace: :tp)

    resource_manager2 = area2.resource_manager
    resource_manager2.add_resource_expand_path('spec/k_manager/scenarios/simple/countries.csv')
    resource_manager2.add_resource_expand_path('spec/k_manager/scenarios/simple/traveling-people.json')
    resource_manager2.add_resource_expand_path('spec/k_manager/scenarios/simple/ben-dover.jason', content_type: :json) # provide content type when it cannot be inferred
    resource_manager2.add_resource_expand_path('spec/k_manager/scenarios/simple/me.txt')
    resource_manager2.add_resource_expand_path('spec/k_manager/scenarios/simple/not-found.txt')
    resource_manager2.add_resource_expand_path('spec/k_manager/scenarios/simple/not-found.rb')
    resource_manager2.add_resource_expand_path('spec/k_manager/scenarios/simple/query.rb')
    resource_manager2.add_resource_expand_path('spec/k_manager/scenarios/simple/rich_data.rb')

    KManager.fire_actions(:load_content, :register_document, :load_document)

    dashboard = KManager::Overview::Dashboard.new(KManager.manager)
    # dashboard.areas
    dashboard.resources
    dashboard.documents

    # resource_manager1.add_resource_expand_path('spec/k_manager/scenarios/simple/setup.rb')
    resource_manager2.add_resource_expand_path('spec/k_manager/scenarios/simple/setup.rb')

    log.error('-' * 74)

    KManager.fire_actions(:load_content, :register_document, :load_document)

    # dashboard.areas
    # dashboard.resources
    # dashboard.documents

    dump = KManager::Overview::DumpJson.new('spec/k_manager/scenarios/dumps', KManager)
    dump.areas('manager_spec.areas.json')
    dump.resources('manager_spec.resources.json')
    dump.documents('manager_spec.documents.json')
  end

  context 'initialized' do
    context '.areas' do
      subject { instance.areas }

      it { is_expected.to be_empty }
    end
  end

  describe '#add_area' do
    before { instance.add_area(:abc, namespace: :abc) }

    describe '.find_area' do
      context 'when are exists' do
        subject { instance.find_area(:abc) }

        it { is_expected.not_to be_nil }
      end
      context 'when are does not exist' do
        subject { instance.find_area(:xhz) }

        it { is_expected.to be_nil }
      end
    end

    context '.areas' do
      subject { instance.areas.length }

      it { is_expected.to eq(1) }

      context 'prevent duplicate area' do
        before { instance.add_area(:abc, namespace: :abc) }

        it { is_expected.to eq(1) }
      end
    end
  end
end
