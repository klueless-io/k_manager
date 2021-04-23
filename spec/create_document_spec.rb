# frozen_string_literal: true

RSpec.describe KManager::CreateDocument do
  context 'module methods' do
    context '.document' do
      subject { KManager.document }

      it { is_expected.not_to be_empty }
    end
  end

  context 'document factories' do
    include described_class

    let(:instance) { described_class }

    context '.document' do
      subject { document }

      it { is_expected.to eq('some_document') }
    end
  end
end
