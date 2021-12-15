# frozen_string_literal: true

require 'spec_helper'

# Convert a resource_uri into a resource
# Example:
#
# file://c/some-file.txt will become a FileResource
# http://my.com/gist will become a WebResource
RSpec.describe KManager::Resources::ResourceFactory do
  subject { instance }

  let(:instance) { described_class.new }
  let(:uri) { KUtil.file.parse_uri(uri_path) }

  context 'initialize' do
    it { is_expected.not_to be_nil }
  end

  describe '#instance' do
    subject { instance.instance(uri, **opts) }
    let(:opts) { {} }

    context 'when given file uri' do
      context 'when unknown file extension' do
        let(:uri_path) { 'some-file.txt' }

        it do
          is_expected
            .to be_a(KManager::Resources::FileResource)
            .and have_attributes(source_path: '/some-file.txt', content_type: :unknown)
        end
      end

      context 'when unknown file extension and content_type is supplied' do
        let(:uri_path) { 'some-file.jason' }
        let(:opts) { { content_type: :json } }

        it do
          is_expected
            .to be_a(KManager::Resources::FileResource)
            .and have_attributes(source_path: '/some-file.jason', content_type: :json)
        end
      end

      context 'when known file extensions' do
        let(:uri_path) { 'some-file.json' }

        it do
          is_expected
            .to be_a(KManager::Resources::FileResource)
            .and have_attributes(source_path: '/some-file.json', content_type: :json)
        end
      end
    end

    context 'when given web uri' do
      context 'when http' do
        let(:uri_path) { 'http://my.com/insecure' }

        it do
          is_expected
            .to be_a(KManager::Resources::WebResource)
            .and have_attributes(source_path: 'http://my.com/insecure', content_type: :unknown)
        end
      end

      context 'when https' do
        let(:uri_path) { 'https://my.com/secure' }

        it do
          is_expected
            .to be_a(KManager::Resources::WebResource)
            .and have_attributes(source_path: 'https://my.com/secure', content_type: :unknown)
        end
      end

      context 'when content_type is provided' do
        let(:uri_path) { 'http://my.com/my.json' }
        let(:opts) { { content_type: :json } }

        it do
          is_expected
            .to be_a(KManager::Resources::WebResource)
            .and have_attributes(source_path: 'http://my.com/my.json', content_type: :json)
        end
      end
    end
  end
end
