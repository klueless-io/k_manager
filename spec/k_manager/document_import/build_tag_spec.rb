# frozen_string_literal: true

# KConfig.configure(:traveling_people_spec) do |config|
#   path = Dir.pwd
#   config.target_folders.add(:app, File.join(path, '.output'))
#   config.template_folders.add(:global , File.join(path, '.global_template'))
#   config.template_folders.add(:app , File.join(path, '.app_template'))
# end

RSpec.describe KManager::DocumentImport::BuildTag do
  subject { instance }

  let(:instance) { described_class.new(key: key, **opts) }
  let(:key) { :xmen }
  let(:opts) { {} }

  context '#tag' do
    subject { instance.tag }
    context 'with key' do
      it { is_expected.to eq(:xmen_container) }

      context 'and namespace' do
        let(:opts) { { namespace: :tp } }

        it { is_expected.to eq(:tp_xmen_container) }
      end

      context 'and type' do
        let(:opts) { { type: :kdoc } }

        it { is_expected.to eq(:xmen_kdoc) }

        context 'and namespace' do
          let(:opts) { { namespace: :tp, type: :csv } }

          it { is_expected.to eq(:tp_xmen_csv) }
        end

        context 'and deep namespace' do
          let(:opts) { { type: :json, namespace: ['a', :b, 'c'] } }

          it { is_expected.to eq(:a_b_c_xmen_json) }
        end
      end
    end
  end

  # context 'setup workflow' do
  #   before do
  #     area1 = KManager.add_area(:xmen)
  #     resource_manager1 = area1.resource_manager
  #     resource_manager1.add_resource_expand_path('spec/k_manager/scenarios/simple/countries.csv')
  #     resource_manager1.add_resource_expand_path('spec/k_manager/scenarios/simple/traveling-people.json')

  #     area2 = KManager.add_area(:traveling_people, namespace: :tp)

  #     resource_manager2 = area2.resource_manager
  #     resource_manager2.add_resource_expand_path('spec/k_manager/scenarios/simple/countries.csv')
  #     resource_manager2.add_resource_expand_path('spec/k_manager/scenarios/simple/traveling-people.json')
  #     resource_manager2.add_resource_expand_path('spec/k_manager/scenarios/simple/ben-dover.jason', content_type: :json) # provide content type when it cannot be inferred
  #     resource_manager2.add_resource_expand_path('spec/k_manager/scenarios/simple/me.txt')
  #     resource_manager2.add_resource_expand_path('spec/k_manager/scenarios/simple/not-found.txt')
  #     resource_manager2.add_resource_expand_path('spec/k_manager/scenarios/simple/not-found.rb')
  #     resource_manager2.add_resource_expand_path('spec/k_manager/scenarios/simple/query.rb')
  #     resource_manager2.add_resource_expand_path('spec/k_manager/scenarios/simple/rich_data.rb')
  #     resource_manager2.add_resource('https://gist.githubusercontent.com/klueless-io/36a53ac9683866d923ce9fa99ccca436/raw/people.csv', content_type: :csv)
  #     resource_manager2.add_resource('https://gist.githubusercontent.com/klueless-io/32397b82f2ba607ce3dc452dcb357a99/raw/site_definition.rb', content_type: :ruby)
  #     resource_manager2.add_resource('https://gist.githubusercontent.com/klueless-io/0140db92d83714caba370fc311973068/raw/string_color.rb', content_type: :ruby)

  #     area3 = KManager.add_area(:samples)
  #     resource_manager3 = area3.resource_manager
  #     resource_manager3.add_resource_expand_path('spec/samples/.builder/data_files/ruby-namespaced-dsl.rb')

  #     KManager.fire_actions(:load_content, :register_document, :load_document)
  #   end

  #   fit 'should display dashboard' do
  #     dashboard = KManager::Overview::Dashboard.new(KManager.manager)
  #     dashboard.areas
  #     dashboard.resources
  #     dashboard.documents
  #   end
  # end
end
