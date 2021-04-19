# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KManager::Project do
  # include KLog::Logging

  # let(:custom_target_folder1) { '~/my-target-folder1' }
  # let(:custom_target_folder2) { '~/my-target-folder2' }

  # let(:expected_target_folder1) { File.expand_path(custom_target_folder1) }
  # let(:expected_target_folder2) { File.expand_path(custom_target_folder2) }

  # let(:custom_template_folder) { '~/my-template-folder' }
  # let(:custom_domain_template_folder) { '~/my-template-folder-domain' }
  # let(:custom_global_template_folder) { '~/my-template-folder-global' }

  # let(:expected_template_folder) { File.expand_path(custom_template_folder) }
  # let(:expected_domain_template_folder) { File.expand_path(custom_domain_template_folder) }
  # let(:expected_global_template_folder) { File.expand_path(custom_global_template_folder) }

  context 'initialize' do
    subject { instance }

    let(:instance) { described_class.new(name, config, opts, &block) }
    let(:name) { :my_project }
    let(:config) { nil }
    let(:opts) { {} }
    let(:block) { ->() {} }

    context 'minimal initialization' do
      it { is_expected.not_to be_nil }

      context '.name' do
        subject { instance.name }
      
        it { is_expected.to eq(:my_project) }
      end

      context '.root_namespace' do
        subject { instance.root_namespace }
      
        it { is_expected.to eq(:my_project) }

        context 'when root_namespace option provided' do
          context 'as blank value' do
            let(:opts) { { root_namespace: '' } }
            
            it { is_expected.to eq('') }
          end
          context 'as custom value' do
            let(:opts) { { root_namespace: :custom } }
            
            it { is_expected.to eq(:custom) }
          end
        end
      end

      context '.config' do
        subject { instance.config }
      
        it { is_expected.not_to be_nil }
      end
    end

    # context '.target_folders' do
    #   subject { instance.target_folders }

    #   it { is_expected.not_to be_nil }
    # end

    # context '.template_folders' do
    #   subject { instance.template_folders }

    #   it { is_expected.not_to be_nil }
    # end

    # context '.github' do
    #   subject { instance.github }

    #   it { is_expected.not_to be_nil }
    # end

    # it { subject.github; puts JSON.pretty_generate(KUtil.data.to_hash(subject)) }
  end
end
