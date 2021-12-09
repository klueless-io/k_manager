# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KManager::Resources::ResourceSet do
  subject { instance }

  let(:instance)  { described_class.new(area) }

  let(:area)      { KManager::Area.new(**area_opts) }
  let(:area_opts) { { name: :hello, namespace: :world } }

  let(:resource_factory)  { KManager::Resources::ResourceFactory.new }

  context 'initialize' do
    context 'with minimal options' do
      it { is_expected.not_to be_nil }

      context '.area' do
        subject { instance.area }
      
        it { is_expected.not_to be_nil }
      end

      context '.resources' do
        subject { instance.resources }
      
        it { is_expected.to be_empty }
      end
    end
  end

  describe '#add_resource' do
    subject { instance.resources }

    let(:resource)          { resource_factory.instance(resource_uri)}
    let(:filename)          { File.expand_path('spec/k_manager/scenarios/simple/countries.csv') }
    let(:resource_uri)      { URI.join('file:///', filename)}

    it { is_expected.to be_empty }

    context 'after add_resource' do
      before { instance.add(resource) }

      it { is_expected.not_to be_empty }

      context '.resources.first' do
        subject { instance.resources.first }
      
        it { is_expected.to have_attributes(scheme: :file, content_type: :csv, status: :alive, infer_key: 'countries', area: area) }
      end

      context 'when adding the same resource twice' do
        subject { instance.resources.length }

        it { is_expected.to eq(1) }

        context 'add resource twice' do
          subject { instance.resources.length }

          # Warning message will render
          before { instance.add(resource) }

          it { is_expected.to eq(1) }
        end
      end
    end
  end

  describe '#add_resources' do
    subject { instance.resources.length }

    let(:file1)       { URI.join('file:///', File.expand_path('spec/k_manager/scenarios/simple/countries.csv') ) }
    let(:file2)       { URI.join('file:///', File.expand_path('spec/k_manager/scenarios/simple/traveling-people.json') ) }
    let(:resources)   { [resource_factory.instance(file1), resource_factory.instance(file2) ] }

    it { is_expected.to be_zero }

    context 'after add_resources' do
      before { instance.add_resources(resources) }

      it { is_expected.to eq(2) }
    end
  end
end
