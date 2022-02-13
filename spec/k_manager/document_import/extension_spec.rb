# frozen_string_literal: true

RSpec.describe KManager::DocumentImport::Extension do
  subject { instance }

  context 'where documents include Document::Extension' do
    context 'when KDoc::Action' do
      let(:instance) { KDoc::Action.new }

      it { is_expected.to respond_to(:import) }
    end

    context 'when KDoc::Model' do
      let(:instance) { KDoc::Model.new }

      it { is_expected.to respond_to(:import) }
    end

    context 'when KDoc::CsvDoc' do
      let(:instance) { KDoc::CsvDoc.new }

      it { is_expected.to respond_to(:import) }
    end

    context 'when KDoc::JsonDoc' do
      let(:instance) { KDoc::JsonDoc.new }

      it { is_expected.to respond_to(:import) }
    end

    context 'when KDoc::YamlDoc' do
      let(:instance) { KDoc::YamlDoc.new }

      it { is_expected.to respond_to(:import) }
    end
  end
end
