# frozen_string_literal: true

KConfig.configure(:traveling_people_spec) do |config|
  path = Dir.pwd
  config.target_folders.add(:app, File.join(path, '.output'))
  config.template_folders.add(:global , File.join(path, '.global_template'))
  config.template_folders.add(:app , File.join(path, '.app_template'))
end

RSpec.describe 'Import Workflows' do
  context 'apply sample workflows' do
    before do
      KManager.reset
      area1 = KManager.add_area(:xmen)
      resource_manager1 = area1.resource_manager
      resource_manager1.add_resource_expand_path('spec/samples/.builder/data_files/ruby-import-dsl.rb')

      # area2 = KManager.add_area(:thunderbirds, namespace: :are_go)
      # resource_manager2 = area2.resource_manager
      # resource_manager2.add_resource_expand_path('spec/samples/.builder/data_files/ruby-import-dsl.rb')

      KManager.fire_actions(:load_content, :register_document, :preload_document, :load_document)
    end

    context 'find document and check imported data' do
      subject { KUtil.data.to_open_struct(document.data) }

      let(:document) { KManager.find_document(key) }

      context 'when simple document' do
        let(:key) { :simple_kdoc }

        it do
          is_expected.to have_attributes(settings:
            have_attributes(
              me: :simple,
              name: 'simple-name',
              description: 'simple-description'
            ))
        end

        describe '#init_block' do
          subject { document.init_block }

          it { is_expected.to be_nil }
        end
      end

      context 'when simple document in deep namespace' do
        let(:key) { :multi_nested_deep_kdoc }

        it do
          is_expected.to have_attributes(settings:
            have_attributes(
              me: :deep,
              name: 'deep-name',
              description: 'deep-description'
            ))
        end
      end

      context 'when using simple initialization' do
        let(:key) { :simple_initialize_kdoc }

        it do
          is_expected.to have_attributes(settings:
            have_attributes(
              me: :simple_initialize,
              name: 'some-name',
              description: 'some-description'
            ))
        end

        describe '#init_block' do
          subject { document.init_block }

          it { is_expected.not_to be_nil }
        end
      end

      context 'when dependant upon another document' do
        let(:key) { :simple_dependency_kdoc }

        it do
          dashboard = KManager::Overview::Dashboard.new(KManager.manager)
          dashboard.resources
          dashboard.documents
          KManager.fire_actions(:load_content, :register_document, :preload_document, :load_document)

          is_expected.to have_attributes(settings:
            have_attributes(
              me: :simple_dependency,
              name: 'import from: simple-name',
              description: 'import from: simple-description'
            ))
        end

        # describe '#init_block' do
        #   subject { document.init_block }

        #   it { is_expected.not_to be_nil }
        # end
      end

      xcontext 'when document imports from multiple document' do
        let(:key) { :multiple_import_kdoc }

        it do
          is_expected.to have_attributes(from_simple:
              have_attributes(
                name: 'simple-name',
                description: 'simple-description'
              ))
            .and have_attributes(from_deep:
              have_attributes(
                name: 'deep-name',
                description: 'deep-description'
              ))
        end
      end

      xcontext 'when recursion a<->b documents' do
        let(:key) { :recursion_a_kdoc }

        # it do
        #   doc = KManager.area_documents.last
        #   doc.debug(include_header: true)
        #   # log.error doc.owner.class.name
        #   # doc.owner.debug
        #   is_expected.to have_attributes(settings:
        #     have_attributes(
        #       me: :recursion_a,
        #       grab: :recursion_b_not_set
        #     ))
        # end
      end
    end

    def debug
      dashboard = KManager::Overview::Dashboard.new(KManager.manager)
      # dashboard.areas
      # dashboard.resources
      dashboard.documents
    end
  end
end
