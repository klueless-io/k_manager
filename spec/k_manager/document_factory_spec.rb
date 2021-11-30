# frozen_string_literal: true

RSpec.describe KManager::DocumentFactory do
  # TODO: Maybe move this
  # context 'module methods' do
  #   context '.model' do
  #     subject { KManager.model }

  #     it { is_expected.not_to be_nil }
  #   end
  #   context '.csv' do
  #     subject { KManager.csv }

  #     it { is_expected.not_to be_nil }
  #   end
  #   context '.json' do
  #     subject { KManager.json }

  #     it { is_expected.not_to be_nil }
  #   end
  #   context '.yaml' do
  #     subject { KManager.yaml }

  #     it { is_expected.not_to be_nil }
  #   end
  # end

  context 'document factories' do
    include described_class

    let(:instance) { described_class }

    context 'when resource unattached' do
      context '.model' do
        subject { model }

        it { is_expected.to be_a(KDoc::Model).and have_attributes(owner: be_nil) }
      end
      context '.csv' do
        subject { csv }

        it { is_expected.to be_a(KDoc::CsvDoc).and have_attributes(owner: be_nil) }
      end
      context '.json' do
        subject { json }

        it { is_expected.to be_a(KDoc::JsonDoc).and have_attributes(owner: be_nil) }
      end
      context '.yaml' do
        subject { yaml }

        it { is_expected.to be_a(KDoc::YamlDoc).and have_attributes(owner: be_nil) }
      end
    end
    context 'when resource attached' do
      let(:resource) { KManager::Resources::BaseResource.new({}) }

      around(:each) do |example|
        for_resource(resource) do |_resource|
          example.run
        end
      end

      # context '.model' do
      #   subject { model }

      #   it { is_expected.to be_a(KDoc::Model).and have_attributes(owner: resource) }
      # end
      context '.csv' do
        subject { csv }

        it { is_expected.to be_a(KDoc::CsvDoc).and have_attributes(owner: resource) }
      end
      context '.json' do
        subject { json }

        it { is_expected.to be_a(KDoc::JsonDoc).and have_attributes(owner: resource) }
      end
      context '.yaml' do
        subject { yaml }

        it { is_expected.to be_a(KDoc::YamlDoc).and have_attributes(owner: resource) }
      end
    end
  end
end
