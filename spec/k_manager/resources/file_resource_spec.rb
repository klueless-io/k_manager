# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KManager::Resources::FileResource do
  let(:instance) { described_class.new(**opts) }
  let(:opts) { { file: file } }
  let(:file) { '/path/to/file' }
  let(:project1) { KManager::Project.new(:project1) }

  context 'initialize' do
    subject { instance }

    context 'minimal initialization' do
      it { is_expected.not_to be_nil }

      context '.source' do
        subject { instance.source }

        it { is_expected.to eq(:file) }
      end

      context 'file not supplied' do
        let(:opts) { {} }

        it { expect { subject }.to raise_error(KType::Error, 'File resource requires a file option') }
      end
    end

    describe '#instance (factory method)' do
      subject { described_class.instance(**opts) }

      context 'when ruby file' do
        let(:file) { 'file.rb' }
        it { is_expected.to be_a(KManager::Resources::RubyFileResource) }
      end

      context 'when csv file' do
        let(:file) { 'file.csv' }
        it { is_expected.to be_a(KManager::Resources::CsvFileResource) }
      end

      context 'when json file' do
        let(:file) { 'file.json' }
        it { is_expected.to be_a(KManager::Resources::JsonFileResource) }
      end

      context 'when yaml file' do
        let(:file) { 'file.yaml' }
        it { is_expected.to be_a(KManager::Resources::YamlFileResource) }
      end

      context 'when text file' do
        let(:file) { 'file.txt' }
        it { is_expected.to be_a(KManager::Resources::UnknownFileResource) }
      end
    end
  end

  context 'fire actions' do
    subject { instance }

    it { is_expected.to have_attributes(status: :initialized, content: be_nil) }

    context 'when action fired :load_content' do
      before { instance.fire_action(:load_content) }

      context 'when file does not exist' do
        let(:file) { '/path/to/file' }

        it { is_expected.to have_attributes(status: :content_loaded, content: be_nil) }
      end

      context 'when file exists' do
        let(:file) { 'spec/samples/.builder/data_files/PersonDetails.json' }

        it { is_expected.to have_attributes(status: :content_loaded) }

        context '.content' do
          subject { instance.content }

          it { is_expected.not_to be_empty }
        end

        context '.infer_key' do
          subject { instance.infer_key }

          it { is_expected.to eq('person-details') }
        end
      end
    end
  end
end
