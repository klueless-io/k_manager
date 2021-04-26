# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KManager::Resources::RubyFileResource do
  let(:instance) { described_class.instance(**opts) }
  let(:opts) { { file: file } }
  let(:file) { 'spec/samples/.builder/data_files/one_dsl.rb' }
  let(:project1) { KManager::Project.new(:project1) }

  context 'fire actions' do
    subject { instance }

    it do
      is_expected.to have_attributes(status: :initialized,
                                     content: be_nil,
                                     document: be_nil,
                                     documents: be_empty)
    end

    context 'when action fired :load_content' do
      before { instance.fire_action(:load_content) }

      it {
        is_expected.to have_attributes(
          status: :content_loaded,
          content: be_present,
          document: be_nil,
          documents: be_empty
        )
      }
    end

    context 'when action fired :register_document' do
      before do
        instance.fire_action(:load_content)
        instance.fire_action(:register_document)
      end

      it do
        is_expected
          .to have_attributes(
            status: :documents_registered,
            content: be_present,
            document: be_a(KManager::Documents::ModelDocument),
            documents: have_attributes(length: 1)
          )
          .and have_attributes(document: have_attributes(type: :entity))
      end
    end
  end
end
