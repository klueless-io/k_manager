# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KManager::Resources::ResourceDocumentFactory do
  subject { instance }

  let(:instance) { described_class }
  let(:file_resource) { KManager::Resources::FileResource.new(file: file).tap(&:fire_next_action) }
  let(:mem_resource) { KManager::Resources::MemResource.new(content: content, content_type: content_type).tap(&:fire_next_action) }
  let(:resource) { file_resource }

  let(:file) { 'spec/samples/.builder/data_files/some-file.txt' }
  let(:content) { nil }
  let(:content_type) { nil }

  context 'initialize' do
    it { is_expected.not_to be_nil }
  end

  describe '.resource.documents' do
    subject { resource.documents }

    it { is_expected.to have_attributes(length: 0) }

    describe '#create_documents' do
      before { instance.create_documents(resource) }

      context 'csv file' do
        let(:file) { 'spec/samples/.builder/data_files/countries.csv' }
        it { is_expected.to have_attributes(length: 1) }
      end
      context 'json file' do
        let(:file) { 'spec/samples/.builder/data_files/PersonDetails.json' }
        it { is_expected.to have_attributes(length: 1) }
      end
      context 'yaml file' do
        let(:file) { 'spec/samples/.builder/data_files/sample-yaml-list.yaml' }
        it { is_expected.to have_attributes(length: 1) }
      end
    end
  end

  describe '#create_documents' do
    before { instance.create_documents(resource) }

    describe '.document (first document in the array)' do
      subject { resource.document }

      context 'when csv content' do
        context 'valid csv file' do
          let(:file) { 'spec/samples/.builder/data_files/countries.csv' }

          it {
            is_expected
              .to have_attributes(
                key: 'countries',
                type: :csv,
                data: include(code: 'AU', country: 'Australia')
              )
              .and have_attributes(data: have_attributes(length: 5))
          }
        end

        context 'invalid csv content' do
          let(:content) { "aaa\",bbb\naaa,bbb" }
          let(:content_type) { :csv }
          let(:resource) { mem_resource }

          it { is_expected.to have_attributes(type: :csv, data: []) }
        end
      end

      context 'when json content' do
        context 'valid json file' do
          let(:file) { 'spec/samples/.builder/data_files/PersonDetails.json' }

          it do
            is_expected
              .to have_attributes(
                key: 'person_details',
                type: :json,
                namespace: [],
                data: include('firstName' => 'Rack', 'lastName' => 'Jackson', 'gender' => 'man', 'age' => 24)
              )
          end
        end

        context 'invalid json content' do
          let(:content) { 'this is not json' }
          let(:content_type) { :json }
          let(:resource) { mem_resource }

          it { is_expected.to have_attributes(type: :json, data: {}) }
        end
      end

      context 'when yaml content' do
        context 'valid yaml content in list format' do
          let(:file) { 'spec/samples/.builder/data_files/sample-yaml-list.yaml' }

          it do
            is_expected
              .to have_attributes(
                key: 'sample_yaml_list',
                type: :yaml,
                data: include(
                  include({ 'dave' => { 'job' => 'Developer', 'name' => 'David', 'skills' => %w[python perl pascal] } }),
                  include({ 'jin' => { 'job' => 'Developer', 'name' => 'Jin', 'skills' => %w[lisp fortran erlang] } })
                )
              )
          end
        end

        context 'valid yaml content in object format' do
          let(:file) { 'spec/samples/.builder/data_files/sample-yaml-object.yaml' }

          it do
            is_expected
              .to have_attributes(
                key: 'sample_yaml_object',
                type: :yaml,
                data: include(
                  { 'people' => [
                    { 'dave' => { 'job' => 'Developer', 'name' => 'David', 'skills' => %w[python perl pascal] } },
                    { 'jin' => { 'job' => 'Developer', 'name' => 'Jin', 'skills' => %w[lisp fortran erlang] } }
                  ] }
                )
              )
          end
        end

        context 'invalid yaml content' do
          let(:content) { '*** this is not yaml ***' }
          let(:content_type) { :yaml }
          let(:resource) { mem_resource }

          it { is_expected.to have_attributes(type: :yaml, data: {}) }
        end
      end
    end
  end

  describe '#create_documents (using ruby resources)' do
    before { instance.create_documents(resource) }

    subject { resource.documents }

    context 'when plain ruby file content' do
      it { expect { Simple.new }.to raise_error(NameError) }

      context 'valid ruby file' do
        let(:file) { 'spec/samples/.builder/data_files/ruby-simple.rb' }

        it { is_expected.to have_attributes(length: 0) }
        it { expect(defined? Simple).to be_truthy }
      end
    end

    context 'when ruby file with 1 DSL' do
      context 'valid ruby file' do
        let(:file) { 'spec/samples/.builder/data_files/ruby-1-dsl.rb' }

        it { is_expected.to have_attributes(length: 1) }
      end
    end

    context 'when ruby file with 4 DSL' do
      context 'valid ruby file' do
        let(:file) { 'spec/samples/.builder/data_files/ruby-4-dsl.rb' }

        it { is_expected.to have_attributes(length: 4) }
      end
    end

    context 'when ruby file with 7 DSL' do
      context 'valid ruby file' do
        let(:file) { 'spec/samples/.builder/data_files/ruby-7-dsl.rb' }

        it { is_expected.to have_attributes(length: 7) }
      end
    end
  end
end
