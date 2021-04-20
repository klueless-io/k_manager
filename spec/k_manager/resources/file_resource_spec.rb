# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KManager::Resources::FileResource do
  context 'initialize' do
    subject { instance }

    let(:instance) { described_class.new(**opts) }
    let(:opts) { { file: file } }
    let(:file) { '/path/to/file' }
    let(:project1) { KManager::Project.new(:project1) }

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
end
