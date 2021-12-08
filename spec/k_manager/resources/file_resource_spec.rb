# frozen_string_literal: true

require 'spec_helper'

RSpec.shared_examples :content_type_inferred_from_file do |expected_type, path|
  let(:file) { path }

  subject { instance.content_type }

  it { is_expected.to eq(expected_type) }
end

RSpec.shared_examples :content_type_via_options do |expected_type, path|
  let(:file) { path }
  let(:opts) { { file: file, content_type: expected_type } }

  subject { instance.content_type }

  it { is_expected.to eq(expected_type) }
end

RSpec.describe KManager::Resources::FileResource do
  let(:instance) { described_class.new(**opts) }
  let(:opts) { { file: file } }
  let(:file) { '/path/to/some_file' }

  # let(:project1) { KManager::Project.new(:project1) }

  context 'initialize' do
    subject { instance }

    it { is_expected.not_to be_nil }

    it { is_expected.to be_alive }

    context '.uri' do
      subject { instance.uri }

      it { is_expected.not_to be_nil }
    end

    context '.default_scheme' do
      subject { instance.default_scheme }

      it { is_expected.to eq(:file) }
    end

    context '.scheme' do
      subject { instance.scheme }

      it { is_expected.to eq(:file) }
    end

    context '.content_type' do
      subject { instance.content_type }

      it { is_expected.to eq(:unknown) }
    end

    context '.infer_key' do
      subject { instance.infer_key }

      it { is_expected.to eq('some_file') }
    end

    context '.file' do
      subject { instance.file }

      it { is_expected.not_to be_nil }
    end

    context 'file not supplied' do
      let(:opts) { {} }

      it { expect { subject }.to raise_error(KType::Error, 'File resource requires a file option') }
    end

    describe '.resource_path' do
      context 'when file exists' do
        let(:file) { 'spec/samples/.builder/data_files/some-file.txt' }
        context '.resource_path' do
          subject { instance.resource_path }

          it { is_expected.to eq(File.expand_path(file)) }
        end
        context '.resource_valid?' do
          subject { instance.resource_valid? }

          it { is_expected.to be_truthy }
        end
      end

      context 'when file does not exist' do
        let(:file) { 'spec/samples/.builder/data_files/bad-to-the-bone.txt' }
        context '.resource_path' do
          subject { instance.resource_path }

          it { is_expected.to eq(File.expand_path(file)) }
        end
        context '.resource_valid?' do
          subject { instance.resource_valid? }

          it { is_expected.to be_falsey }
        end
      end
    end

    context '#fire_action' do
      subject { instance }

      let(:file) { 'spec/samples/.builder/data_files/countries.csv' }

      context 'when alive' do
        it { is_expected.to be_alive }

        context 'if using invalid action :load_document' do
          before { instance.fire_action(:load_document) }

          it { is_expected.to be_alive }
        end

        context 'when using valid action :load_content' do
          before { instance.fire_action(:load_content) }

          it { is_expected.to be_content_loaded }

          context 'when content_loaded' do
            context 'if using invalid action :load_document' do
              before { instance.fire_action(:load_document) }

              context 'status remains unchanged' do
                it { is_expected.to have_attributes(status: :content_loaded) }
              end

              context 'when using next action :register_document' do
                before { instance.fire_action(:register_document) }

                context 'advance the status' do
                  it { is_expected.to have_attributes(status: :documents_registered) }
                end

                # describe '#debug' do
                #   subject { instance.debug }

                #   it { subject }
                # end
              end
            end
          end
        end
      end
    end
  end

  context '.uri' do
    subject { instance.uri }

    let(:file_path) { 'spec/samples/.builder/data_files/some-file.txt' }
    let(:file) { file_path }

    context 'when valid file provided' do
      it { is_expected.not_to be_nil }
      it { is_expected.to be_a(URI::File) }

      context '.uri.path' do
        subject { instance.uri.path }

        it { is_expected.to eq(File.expand_path(file)) }
      end
    end

    context 'when valid file provided as URI::File' do
      let(:file) { URI::File.build(host: nil, path: File.expand_path(file_path)) }

      it { is_expected.not_to be_nil }
      it { is_expected.to be_a(URI) }
    end
  end

  context '.content_type' do
    context 'when inferred from the filename' do
      it_behaves_like :content_type_inferred_from_file, :csv  , 'spec/samples/.builder/data_files/countries.csv'
      it_behaves_like :content_type_inferred_from_file, :json , 'spec/samples/.builder/data_files/PersonDetails.json'
      it_behaves_like :content_type_inferred_from_file, :yaml , 'spec/samples/.builder/data_files/developers.yaml'
      it_behaves_like :content_type_inferred_from_file, :ruby , 'spec/samples/.builder/data_files/ruby-simple.rb'
    end
    context 'when configured via param' do
      it_behaves_like :content_type_via_options       , :csv  , 'spec/samples/.builder/data_files/countries.csv.weird_ext'
      it_behaves_like :content_type_via_options       , :json , 'spec/samples/.builder/data_files/PersonDetails.json.weird_ext'
      it_behaves_like :content_type_via_options       , :yaml , 'spec/samples/.builder/data_files/developers.yaml.weird_ext'
      it_behaves_like :content_type_via_options       , :ruby , 'spec/samples/.builder/data_files/ruby-simple.rb.weird_ext'
    end
    # context 'when configured via content sniffing' do
    #   it_behaves_like :content_type_via_options       , :csv  , 'spec/samples/.builder/data_files/countries.csv.weird_ext'
    #   it_behaves_like :content_type_via_options       , :json , 'spec/samples/.builder/data_files/PersonDetails.json.weird_ext'
    #   it_behaves_like :content_type_via_options       , :yaml , 'spec/samples/.builder/data_files/developers.yaml.weird_ext'
    #   it_behaves_like :content_type_via_options       , :ruby , 'spec/samples/.builder/data_files/ruby-simple.rb.weird_ext'
    # end
  end

  context 'fire actions' do
    subject { instance }

    it { is_expected.to have_attributes(status: :alive, content: be_nil) }

    context 'when action fired :load_content' do
      before { instance.fire_action(:load_content) }

      context 'when file does not exist' do
        let(:file) { '/path/to/file' }

        it { is_expected.to have_attributes(status: :content_loaded, content: be_nil) }
      end

      context 'when file exists' do
        let(:file) { 'spec/samples/.builder/data_files/PersonDetails.json' }

        it { is_expected.to have_attributes(status: :content_loaded) }

        context '.content' do
          subject { instance.content }

          it { is_expected.not_to be_empty }
        end

        context '.infer_key' do
          subject { instance.infer_key }

          it { is_expected.to eq('person_details') }
        end

        describe '#debug' do
          subject { instance.debug }

          it { subject }
        end
      end
    end
  end
end
