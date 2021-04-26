# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KManager::Documents::BasicDocument do
  let(:instance) { described_class.new(**opts) }

  let(:opts) do
    {
      key: key,
      type: type,
      namespace: namespace,
      resource: resource
    }
  end

  describe '#constructor' do
    subject { instance }

    context 'with minimal options' do
      let(:key) { nil }
      let(:type) { nil }
      let(:namespace) { nil }
      let(:resource) { nil }

      it do
        is_expected.to have_attributes(
          key: match(/^[A-Za-z0-9]{4}$/),
          type: :basic,
          namespace: '',
          resource: nil,
          project: nil,
          error: nil,
          unique_key: end_with('-basic')
        )
      end
    end

    context 'with all options' do
      let(:key) { :abc }
      let(:type) { :xyz }
      let(:namespace) { :spaceman }
      let(:resource) { KManager::Resources::BaseResource.new(project: project) }
      let(:project) { KManager::Project.new(:my_project) }

      it do
        is_expected.to have_attributes(
          key: :abc,
          type: :xyz,
          namespace: :spaceman,
          project: be_present,
          resource: be_present,
          project_key: 'my-project',
          error: nil,
          unique_key: 'my-project-spaceman-abc-xyz'
        )
      end
    end
  end
end
