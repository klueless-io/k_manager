# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KManager::Resources::BaseResource do
  let(:instance) { described_class.new(uri, **opts) }
  let(:uri_value) { '/some_file' }
  let(:uri) { KUtil.file.parse_uri(uri_value) }
  let(:opts) { {} }

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

        it { is_expected.to eq(:unknown) }
      end

      context '.scheme' do
        subject { instance.scheme }

        it { is_expected.to eq(:file) }
      end

      context '.host' do
        subject { instance.host }

        it { is_expected.to eq('') }
      end

      context '.content_type' do
        subject { instance.content_type }

        it { is_expected.to eq(:unknown) }
      end

      context '.infer_key' do
        subject { instance.infer_key }

        it { is_expected.to be_nil }
      end

      context '.content' do
        subject { instance.content }

        it { is_expected.to be_nil }
      end

      context '.namespace' do
        subject { instance.namespace }

        it { is_expected.to be_nil }
      end

      context '.documents' do
        subject { instance.documents }

        it { is_expected.to be_empty }
      end
    end
  end

  describe '#uri=' do
    before { instance.uri = uri }

    context '.uri' do
      subject { instance.uri }

      context 'when valid uri provided' do
        let(:uri) { 'www.url.com/a' }

        it { is_expected.not_to be_nil }
        it { is_expected.to be_a(URI::Generic) }

        context '.uri.path' do
          subject { instance.uri.path }

          it { is_expected.to eq(uri) }
        end
      end

      context 'when valid uri provided as URI' do
        let(:uri) { URI('www.url.com/a') }

        it { is_expected.not_to be_nil }
        it { is_expected.to be_a(URI::Generic) }

        context '.uri.path' do
          subject { instance.uri.path }

          it { is_expected.to eq(uri.path) }
        end
      end
    end
  end

  context 'fire actions' do
    subject { instance }

    context 'when alive' do
      it { is_expected.to have_attributes(status: :alive) }
      it { is_expected.to be_alive }

      context 'if using invalid action :load_document' do
        before { instance.fire_action(:load_document) }

        context 'status remains unchanged' do
          it { is_expected.to be_alive }
        end
      end

      context 'when using next action :load_content' do
        before { instance.fire_action(:load_content) }

        context 'advance the status' do
          it { is_expected.to be_content_loaded }
        end

        context 'when content_loaded' do
          context 'if using invalid action :load_document' do
            before { instance.fire_action(:load_document) }

            context 'status remains unchanged' do
              it { is_expected.to have_attributes(status: :content_loaded) }
            end
          end

          context 'when using next action :register_document' do
            before { instance.fire_action(:register_document) }

            context 'advance the status' do
              it { is_expected.to have_attributes(status: :documents_registered) }
            end
          end
        end
      end
    end

    context 'when firing actions in sequence' do
      # before { instance.fire_action(:load_document) }
      it { is_expected.to be_alive }

      context '#fire_next_action' do
        before { instance.fire_next_action }

        it { is_expected.to be_content_loaded }

        context '#fire_next_action' do
          before { instance.fire_next_action }

          it { is_expected.to be_documents_registered }

          context '#fire_next_action' do
            before { instance.fire_next_action }

            it { is_expected.to be_documents_preloaded }

            context '#fire_next_action' do
              before { instance.fire_next_action }

              it { is_expected.to be_documents_loaded }
            end
          end
        end
      end
    end
  end
end
