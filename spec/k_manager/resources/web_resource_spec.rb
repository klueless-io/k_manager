# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KManager::Resources::WebResource do
  let(:instance) { described_class.new(uri, **opts) }
  let(:uri) { KUtil.file.parse_uri(url) }
  let(:opts) { {} }
  let(:good_url) { 'https://gist.githubusercontent.com/klueless-io/992d62c1c5aff46706901757bf6030ce/raw/2b26c30be48e2eed76a03960d5ef69bf5fe71dad/klueless-gist' }
  let(:bad_url) { 'https://gist.githubusercontent.com/klueless-io/bad-url' }
  let(:url) { good_url }
  # let(:project1) { KManager::Project.new(:project1) }

  context 'initialize' do
    subject { instance }

    context 'minimal initialization' do
      it { is_expected.not_to be_nil }

      it { is_expected.to be_alive }

      context '.uri' do
        subject { instance.uri }

        it { is_expected.not_to be_nil }
      end

      context '.default_scheme' do
        subject { instance.default_scheme }

        it { is_expected.to eq(:https) }
      end

      context '.scheme' do
        subject { instance.scheme }

        it { is_expected.to eq(:https) }
      end

      context '.host' do
        subject { instance.host }

        it { is_expected.to eq('gist.githubusercontent.com') }
      end

      context '.content_type' do
        subject { instance.content_type }

        it { is_expected.to eq(:unknown) }
      end

      context '.infer_key' do
        subject { instance.infer_key }

        it { is_expected.to eq('klueless_gist') }
      end

      context '.source_path' do
        subject { instance.source_path }

        it { is_expected.not_to be_nil }
      end

      describe '.resource_path' do
        context 'when url exists' do
          context '.resource_path' do
            subject { instance.resource_path }

            it { is_expected.to eq(url) }
          end
          context '.resource_valid?' do
            subject { instance.resource_valid? }

            it { is_expected.to be_truthy }
          end
        end

        context 'when file does not exist' do
          let(:url) { bad_url }
          context '.resource_path' do
            subject { instance.resource_path }

            it { is_expected.to eq(url) }
          end
          context '.resource_valid?' do
            subject { instance.resource_valid? }

            it { is_expected.to be_falsey }
          end
        end
      end
    end
  end

  context 'fire actions' do
    subject { instance }

    it { is_expected.to have_attributes(status: :alive, content: be_nil) }

    context 'when action fired :load_content' do
      before { instance.fire_action(:load_content) }

      context 'when url does not exist' do
        let(:url) { bad_url }

        it { is_expected.to have_attributes(status: :content_loaded, content: be_nil) }
      end

      context 'when url exists' do
        let(:url) { good_url }

        it { is_expected.to have_attributes(status: :content_loaded) }

        context '.content' do
          subject { instance.content }

          it { is_expected.not_to be_empty }
        end

        context '.infer_key' do
          subject { instance.infer_key }

          it { is_expected.to eq('klueless_gist') }
        end

        # describe '#debug' do
        #   subject { instance.debug }

        #   it { subject }
        # end
      end
    end
  end
end
