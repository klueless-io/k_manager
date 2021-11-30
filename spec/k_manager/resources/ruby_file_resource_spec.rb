# # frozen_string_literal: true

# require 'spec_helper'

# RSpec.describe KManager::Resources::RubyFileResource do
#   let(:instance) { described_class.instance(**opts) }
#   let(:opts) { { file: file } }
#   let(:file) { 'spec/samples/.builder/data_files/simple.rb' }
#   let(:project1) { KManager::Project.new(:project1) }

#   context 'initialize' do
#     subject { instance }

#     context 'minimal initialization' do
#       it { is_expected.not_to be_nil }
#       it { is_expected.to be_a(KManager::Resources::RubyFileResource) }

#       context '.type' do
#         subject { instance.type }

#         it { is_expected.to eq(:ruby) }
#       end
#     end
#   end

#   context 'fire actions' do
#     subject { instance }

#     it do
#       is_expected.to have_attributes(status: :initialized,
#                                      content: be_nil,
#                                      document: be_nil,
#                                      documents: be_empty)
#     end

#     context 'when action fired :load_content' do
#       before { instance.fire_action(:load_content) }

#       it {
#         is_expected.to have_attributes(
#           status: :content_loaded,
#           content: be_present,
#           document: be_nil,
#           documents: be_empty
#         )
#       }
#     end

#     context 'when action fired :register_document' do
#       before do
#         instance.fire_action(:load_content)
#         instance.fire_action(:register_document)
#       end

#       it do
#         is_expected
#           .to have_attributes(
#             status: :documents_registered,
#             content: be_present,
#             document: be_a(KManager::Documents::BasicDocument),
#             documents: have_attributes(length: 1)
#           )
#           .and have_attributes(document: have_attributes(unique_key: 'simple-ruby'))
#       end
#     end

#     context 'when action fired :load_document' do
#       before do
#         instance.fire_action(:load_content)
#         instance.fire_action(:register_document)
#         instance.fire_action(:load_document)
#       end

#       it do
#         is_expected
#           .to have_attributes(
#             status: :documents_loaded,
#             content: be_present,
#             document: be_a(KManager::Documents::BasicDocument),
#             documents: have_attributes(length: 1)
#           )
#           .and have_attributes(document: have_attributes(unique_key: 'simple-ruby'))
#       end

#       describe '#debug' do
#         subject { instance.debug }

#         fit { subject }
#       end
#     end
#   end
# end
