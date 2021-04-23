# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KManager::Resources::UnknownFileResource do
  let(:instance) { described_class.instance(**opts) }
  let(:opts) { { file: file } }
  let(:file) { 'spec/samples/.builder/data_files/some-file.txt' }
  let(:project1) { KManager::Project.new(:project1) }

  context 'initialize' do
    subject { instance }

    context 'minimal initialization' do
      it { is_expected.not_to be_nil }
      it { is_expected.to be_a(KManager::Resources::UnknownFileResource) }

      context '.type' do
        subject { instance.type }

        it { is_expected.to eq(:unknown) }
      end
    end
  end

  context 'fire actions' do
    subject { instance }

    it { is_expected.to have_attributes(status: :initialized, content: be_nil) }

    context 'when action fired :load_content' do
      before { instance.fire_action(:load_content) }

      context '.status' do
        subject { instance.status }

        it { is_expected.to eq(:content_loaded) }
      end

      context '.content' do
        subject { instance.content }

        it { is_expected.not_to be_empty }
      end

      context '.documents' do
        subject { instance.documents }

        it { is_expected.to be_empty }
      end
    end

    context 'when action fired :register_document' do
      before do
        instance.fire_action(:load_content)
        instance.fire_action(:register_document)
      end

      context '.status' do
        subject { instance.status }

        it { is_expected.to eq(:documents_registered) }
      end

      context '.documents' do
        subject { instance.documents }

        it { is_expected.to have_attributes(length: 1) }
      end

      context '.documents.first' do
        subject { instance.documents.first }

        it { is_expected.to have_attributes(unique_key: 'some-file-unknown') }

        context 'when project with namespace' do
          let(:opts) { { project: project1, file: file } }

          it { is_expected.to have_attributes(unique_key: 'project1-some-file-unknown') }
        end
      end
    end

    context 'when action fired :load_document' do
      before do
        instance.fire_action(:load_content)
        instance.fire_action(:register_document)
        instance.fire_action(:load_document)
      end

      context '.status' do
        subject { instance.status }

        it { is_expected.to eq(:documents_loaded) }
      end

      context '.document.data' do
        subject { instance.document.data }

        it { is_expected.to eq({}) }
      end
    end
  end
end
