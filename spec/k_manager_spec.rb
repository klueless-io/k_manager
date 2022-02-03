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

  describe '.opts' do
    subject { KManager.opts }

    it { is_expected.not_to be_nil }

    describe '.app_name' do
      subject { KManager.opts.app_name }

      it { is_expected.to be_empty }
    end

    describe '.exception_style' do
      subject { KManager.opts.exception_style }

      it { is_expected.to eq(:message) }
    end

    describe '.reboot_on_kill' do
      subject { KManager.opts.reboot_on_kill }

      it { is_expected.not_to be_nil }
    end

    describe '.reboot_sleep' do
      subject { KManager.opts.reboot_sleep }

      it { is_expected.to eq(1) }
    end

    describe '.sleep' do
      subject { KManager.opts.sleep }

      it { is_expected.to be_zero }
    end

    describe '.show' do
      subject { KManager.opts.show }

      it { is_expected.not_to be_nil }
    end

    describe '.show' do
      subject { KManager.opts.show }

      it { is_expected.not_to be_nil }

      describe '.time_taken' do
        subject { KManager.opts.show.time_taken }

        it { is_expected.not_to be_nil }
      end

      describe '.finished' do
        subject { KManager.opts.show.finished }

        it { is_expected.not_to be_nil }
      end

      describe '.finished_message' do
        subject { KManager.opts.show.finished_message }

        it { is_expected.not_to be_nil }
      end
    end
  end
end
