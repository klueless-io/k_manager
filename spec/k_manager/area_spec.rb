# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KManager::Area do
  let(:instance) { described_class.new(**opts) }

  context 'initialize' do
    subject { instance }

    let(:opts) { { name: :hello } }

    context 'initialization' do
      context 'with minimal options' do
        it { is_expected.not_to be_nil }

        context '.name' do
          subject { instance.name }

          it { is_expected.to eq(:hello) }
        end

        context '.namespace' do
          subject { instance.namespace }

          it { is_expected.to eq(:hello) }
        end

        context '.resource_manager' do
          subject { instance.resource_manager }

          it { is_expected.not_to be_nil }
        end
      end
      context 'with common options' do
        let(:opts) { { name: :hello, namespace: :world } }

        it { is_expected.to have_attributes(name: :hello, namespace: :world) }
      end
    end
  end
end
