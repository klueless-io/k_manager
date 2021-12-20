# frozen_string_literal: true

RSpec.describe KManager::DocumentFactory do
  context 'document factories' do
    let(:instance) { described_class.new }

    context 'when resource unattached' do
      context '.action' do
        subject { instance.action }

        it { is_expected.to be_a(KDoc::Action).and have_attributes(owner: be_nil) }
      end
      context '.model' do
        subject { instance.model }

        it { is_expected.to be_a(KDoc::Model).and have_attributes(owner: be_nil) }
      end
      context '.csv' do
        subject { instance.csv }

        it { is_expected.to be_a(KDoc::CsvDoc).and have_attributes(owner: be_nil) }
      end
      context '.json' do
        subject { instance.json }

        it { is_expected.to be_a(KDoc::JsonDoc).and have_attributes(owner: be_nil) }
      end
      context '.yaml' do
        subject { instance.yaml }

        it { is_expected.to be_a(KDoc::YamlDoc).and have_attributes(owner: be_nil) }
      end
    end
    context 'when resource attached' do
      let(:resource) { KManager::Resources::BaseResource.new({}) }

      around(:each) do |example|
        KManager.for_resource(resource) do |_resource|
          example.run
        end
      end

      context '.action' do
        subject { instance.action }

        it { is_expected.to be_a(KDoc::Action).and have_attributes(owner: resource) }
      end
      context '.model' do
        subject { instance.model }

        it { is_expected.to be_a(KDoc::Model).and have_attributes(owner: resource) }
      end
      context '.csv' do
        subject { instance.csv }

        it { is_expected.to be_a(KDoc::CsvDoc).and have_attributes(owner: resource) }
      end
      context '.json' do
        subject { instance.json }

        it { is_expected.to be_a(KDoc::JsonDoc).and have_attributes(owner: resource) }
      end
      context '.yaml' do
        subject { instance.yaml }

        it { is_expected.to be_a(KDoc::YamlDoc).and have_attributes(owner: resource) }
      end
    end
  end
end
