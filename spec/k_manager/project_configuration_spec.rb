# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KManager::Configuration::Project do
  include KLog::Logging

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

  describe 'module helper' do
    subject { module_helper }

    let(:module_helper) { KManager.new_project_config(&block) }

    # it { is_expected.not_to be_nil }

    describe '#configure' do
      let(:block) do
        -> (config) do
          # config.target_folders.add(:src, custom_target_folder1)
          # config.target_folders.add(:dst, custom_target_folder2)
  
          # config.template_folders.add(:global , custom_global_template_folder)
          # config.template_folders.add(:domain , custom_domain_template_folder)
          # config.template_folders.add(:app    , custom_template_folder)
            
          config.github.user = 'user'
          config.github.personal_access_token = 'pat'
          config.github.personal_access_token_delete = 'pat_d'
        end
      end

      it { is_expected.not_to be_nil }
        # puts JSON.pretty_generate(subject.to_h)
        # is_expected.to have_attributes(
        #   user: 'user',
        #   personal_access_token: 'pat',
        #   personal_access_token_delete: 'pat_d'
        # )
    end
  end

  context 'initialize' do
    subject { instance }

    let(:instance) { described_class.new }

    it { is_expected.not_to be_nil }

    context '.target_folders' do
      subject { instance.target_folders }

      it { is_expected.not_to be_nil }
    end

    context '.template_folders' do
      subject { instance.template_folders }

      it { is_expected.not_to be_nil }
    end

    context '.github' do
      subject { instance.github }

      it { is_expected.not_to be_nil }
    end

    # it { subject.github; puts JSON.pretty_generate(KUtil.data.to_hash(subject)) }
  end

end
