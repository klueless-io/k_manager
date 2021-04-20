# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KManager::Resources::BaseResource do
  context 'initialize' do
    subject { instance }

    let(:instance) { described_class.new(opts) }
    let(:opts) { {} }
    let(:project1) { KManager::Project.new(:project1) }

    context 'minimal initialization' do
      it { is_expected.not_to be_nil }

      context '.status' do
        subject { instance.status }

        it { is_expected.to eq(:initialized) }
      end

      context '.source' do
        subject { instance.source }

        it { is_expected.to eq(:unknown) }
      end

      context '.type' do
        subject { instance.type }

        it { is_expected.to eq(:unknown) }
      end

      context '.content' do
        subject { instance.content }

        it { is_expected.to be_nil }
      end

      context '.documents' do
        subject { instance.documents }

        it { is_expected.to be_empty }
      end

      context '.project' do
        subject { instance.project }

        it { is_expected.to be_nil }

        context 'when project is provided during initialization' do
          let(:opts) { { project: project1 } }

          it { is_expected.not_to be_nil }

          context 'project.resources' do
            it { expect { subject }.to change(project1.resources, :length).from(0).to(1) }
          end
        end

        describe '#attach_project' do
          context '.project' do
            before { instance.attach_project(project1) }

            it { is_expected.not_to be_nil }
          end

          context 'project.resources' do
            it { expect { instance.attach_project(project1) }.to change(project1.resources, :length).from(0).to(1) }
          end
        end
      end
    end
  end
end
