# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KManager::Area do
  let(:instance) { described_class.new(**opts) }

  context 'initialize' do
    subject { instance }

    let(:opts) { {} }
    # let(:instance) { described_class.new(name, config, **opts, &block) }
    # let(:name) { :my_project }
    # let(:config) { nil }
    # let(:opts) { {} }
    # let(:block) { -> {} }

    context 'initialization' do
      it { is_expected.not_to be_nil }

      context '.name' do
        subject { instance.name }

        it { is_expected.to be_nil }
      end

      context '.namespace' do
        subject { instance.namespace }

        it { is_expected.to be_nil }
      end

      context '.resource_manager' do
        subject { instance.resource_manager }

        it { is_expected.not_to be_nil }
      end
    end
  end
end
