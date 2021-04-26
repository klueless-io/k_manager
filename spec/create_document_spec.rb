# frozen_string_literal: true

RSpec.describe KManager::CreateDocument do
  context 'module methods' do
    context '.model' do
      subject { KManager.model }

      it { is_expected.not_to be_nil }
    end
  end

  context 'document factories' do
    include described_class

    let(:instance) { described_class }

    context '.model' do
      subject { model }

      it { is_expected.to be_a(KManager::Documents::ModelDocument) }
    end
  end
end
