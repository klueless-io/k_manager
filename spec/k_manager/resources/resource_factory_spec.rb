# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KManager::Resources::ResourceFactory do
  subject { instance }

  let(:instance) { described_class.new(**opts) }
  let(:opts) { { file: file } }

  context 'initialize' do
  end
end
