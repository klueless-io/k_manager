# frozen_string_literal: true

RSpec.describe KManager do
  it 'has a version number' do
    expect(KManager::VERSION).not_to be nil
  end

  it 'has a standard error' do
    expect { raise KManager::Error, 'some message' }
      .to raise_error('some message')
  end

  context 'module factory methods' do
    context '.action' do
      subject { KManager.action }

      it { is_expected.not_to be_nil }
    end
    context '.model' do
      subject { KManager.model }

      it { is_expected.not_to be_nil }
    end
    context '.csv' do
      subject { KManager.csv }

      it { is_expected.not_to be_nil }
    end
    context '.json' do
      subject { KManager.json }

      it { is_expected.not_to be_nil }
    end
    context '.yaml' do
      subject { KManager.yaml }

      it { is_expected.not_to be_nil }
    end
  end
end
