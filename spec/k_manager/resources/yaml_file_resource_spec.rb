# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KManager::Resources::YamlFileResource do
  context 'initialize' do
    subject { instance }

    let(:instance) { described_class.instance(**opts) }
    let(:opts) { { file: file } }
    let(:file) { 'spec/samples/.builder/data_files/developers.yaml' }
    let(:project1) { KManager::Project.new(:project1) }

    context 'minimal initialization' do
      it { is_expected.not_to be_nil }
      it { is_expected.to be_a(KManager::Resources::YamlFileResource) }

      context '.type' do
        subject { instance.type }

        it { is_expected.to eq(:yaml) }
      end
    end
  end
end
