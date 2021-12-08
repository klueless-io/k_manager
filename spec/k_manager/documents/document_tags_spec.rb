# frozen_string_literal: true
# # frozen_string_literal: true

# require 'spec_helper'

# RSpec.describe KManager::Documents::DocumentTaggable do
#   let(:instance) { SampleDocument.new(**opts) }

#   let(:project) { KManager::Project.new(:my_project) }

#   let(:opts) do
#     {
#       key: key,
#       type: type,
#       namespace: namespace,
#       resource: resource
#     }
#   end

#   let(:key) { nil }
#   let(:type) { nil }
#   let(:namespace) { nil }
#   let(:resource) { nil }

#   describe '#constructor' do
#     subject { instance }

#     context 'with no key' do
#       it do
#         is_expected.to have_attributes(
#           key: match(/^[A-Za-z0-9]{4}$/),
#           type: :sample,
#           namespace: '',
#           resource: nil,
#           project: nil,
#           error: nil
#         )
#       end
#     end

#     context 'with key' do
#       let(:key) { 'some_name' }

#       it { expect(subject.key).to eq(key) }
#     end

#     context 'with type' do
#       subject { instance.type }

#       context 'when type nil' do
#         let(:type) { nil }

#         it { is_expected.to eq(:sample) }
#       end

#       context 'when type :some_data_type' do
#         let(:type) { :some_data_type }

#         it { is_expected.to eq(:some_data_type) }
#       end
#     end

#     context 'with namespace' do
#       subject { instance.namespace }

#       context 'when namespace nil' do
#         let(:namespace) { nil }

#         it { is_expected.to be_empty }
#       end

#       context 'when namespace :controller' do
#         let(:namespace) { :controller }

#         it { is_expected.to eq(:controller) }
#       end
#     end

#     context 'with project (.project_key)' do
#       subject { instance.project_key }

#       context 'when project nil' do
#         let(:project) { nil }

#         it { is_expected.to be_nil }
#       end

#       context 'when project :controller' do
#         let(:resource) { KManager::Resources::BaseResource.new(project: project) }

#         it { is_expected.to eq('my-project') }
#       end
#     end
#   end

#   describe '.resource' do
#     subject { instance.resource }

#     it { is_expected.to be_nil }

#     context 'set resource' do
#       before { instance.resource = KManager::Resources::BaseResource.new }

#       it { is_expected.not_to be_nil }
#     end
#   end

#   describe '.unique_key' do
#     subject { instance.unique_key }

#     context 'with key' do
#       let(:key) { 'some_name' }

#       it { expect(subject).to eq('some-name-sample') }

#       context 'and type' do
#         let(:type) { :controller }

#         it { expect(subject).to eq('some-name-controller') }

#         context 'and namespace' do
#           let(:namespace) { :controllers }

#           it { expect(subject).to eq('controllers-some-name-controller') }

#           context 'and resource with project' do
#             let(:resource) { KManager::Resources::BaseResource.new(project: project) }

#             it { expect(subject).to eq('my-project-controllers-some-name-controller') }
#           end
#         end
#       end
#     end
#   end
# end
