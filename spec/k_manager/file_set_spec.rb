# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KManager::FileSet do
  let(:instance) { described_class.new }

  fit {
    files = KManager::FileSet.new
      .add('spec/samples/.builder/**/*')

    binding.pry
    # instance.attach_files
  }
end
