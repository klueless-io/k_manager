# frozen_string_literal: true

KConfig.configure(:traveling_people_spec) do |config|
  path = Dir.pwd
  config.target_folders.add(:app, File.join(path, '.output'))
  config.template_folders.add(:global , File.join(path, '.global_template'))
  config.template_folders.add(:app , File.join(path, '.app_template'))
end

RSpec.describe KManager::Manager do
  include KLog::Logging

  let(:instance) { described_class.new }

  # Workflow needs to move into a different file
  it 'workflow' do
    KManager.reset
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
    resource_manager2.add_resource('https://gist.githubusercontent.com/klueless-io/36a53ac9683866d923ce9fa99ccca436/raw/people.csv', content_type: :csv)
    resource_manager2.add_resource('https://gist.githubusercontent.com/klueless-io/32397b82f2ba607ce3dc452dcb357a99/raw/site_definition.rb', content_type: :ruby)
    resource_manager2.add_resource('https://gist.githubusercontent.com/klueless-io/0140db92d83714caba370fc311973068/raw/string_color.rb', content_type: :ruby)

    KManager.boot

    dashboard = KManager::Overview::Dashboard.new(KManager.manager)
    # dashboard.areas
    dashboard.resources
    dashboard.documents

    # resource_manager1.add_resource_expand_path('spec/k_manager/scenarios/simple/setup.rb')
    # resource_manager2.add_resource_expand_path('spec/k_manager/scenarios/simple/setup.rb')

    # log.error('-' * 74)

    # KManager.fire_actions(:load_content, :register_document, :preload_document, :load_document)

    # dashboard.areas
    # dashboard.resources
    # dashboard.documents

    dump = KManager::Overview::DumpJson.new('spec/k_manager/scenarios/dumps', KManager.manager)
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

  context 'query k_manager documents and resources' do
    describe '.area_resources' do
      before do
        rm1 = instance.add_area(:xmen).resource_manager
        rm1.add_resource_expand_path('spec/k_manager/scenarios/simple/countries.csv')

        rm2 = instance.add_area(:traveling_people).resource_manager
        rm2.add_resource_expand_path('spec/k_manager/scenarios/simple/countries.csv')
        rm2.add_resource_expand_path('spec/k_manager/scenarios/simple/traveling-people.json')
      end

      context 'when no area name provided' do
        subject { instance.area_resources }

        it do
          is_expected.to have_attributes(length: 1)

          expect(subject.first.area.name).to eq(:xmen)
        end
      end

      context 'when area name provided' do
        subject { instance.area_resources(area: :traveling_people) }

        it do
          is_expected.to have_attributes(length: 2)

          expect(subject.first.area.name).to eq(:traveling_people)
        end
      end
    end

    describe '.area_documents' do
      before do
        rm1 = instance.add_area(:xmen).resource_manager
        rm1.add_resource_expand_path('spec/k_manager/scenarios/simple/countries.csv')

        rm2 = instance.add_area(:traveling_people).resource_manager
        rm2.add_resource_expand_path('spec/k_manager/scenarios/simple/traveling-people.json')
        rm2.add_resource_expand_path('spec/k_manager/scenarios/simple/countries.csv')

        instance.fire_actions(:load_content, :register_document, :preload_document, :load_document)
      end

      context 'when no area name provided' do
        subject { instance.area_documents }

        it do
          is_expected.to have_attributes(length: 1)

          expect(subject.first.tag).to eq(:countries_csv)
        end
      end

      context 'when area name provided' do
        subject { instance.area_documents(area: :traveling_people) }

        it do
          is_expected.to have_attributes(length: 2)

          expect(subject.first.tag).to eq(:traveling_people_json)
        end
      end
    end

    describe '.find_documents' do
      before do
        rm1 = instance.add_area(:xmen).resource_manager
        rm1.add_resource_expand_path('spec/k_manager/scenarios/simple/countries.csv')

        rm2 = instance.add_area(:traveling_people).resource_manager
        rm2.add_resource_expand_path('spec/k_manager/scenarios/simple/traveling-people.json')

        instance.fire_actions(:load_content, :register_document, :preload_document, :load_document)
      end

      context 'when no area name provided' do
        subject { instance.find_document(name) }

        context 'when document exists in area' do
          let(:name) { :countries_csv }

          it { is_expected.not_to be_nil }
        end

        context 'when document does not exist in area' do
          let(:name) { :traveling_people_json }

          it { is_expected.to be_nil }
        end
      end

      context 'when area name provided' do
        subject { instance.find_document(name, area: :traveling_people) }

        context 'when document exists in area' do
          let(:name) { :traveling_people_json }

          it { is_expected.not_to be_nil }
        end

        context 'when document does not exist in area' do
          let(:name) { :countries_csv }

          it { is_expected.to be_nil }
        end
      end
    end
  end
end
