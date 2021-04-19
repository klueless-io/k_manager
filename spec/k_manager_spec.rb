# frozen_string_literal: true

RSpec.describe KManager do
  it 'has a version number' do
    expect(KManager::VERSION).not_to be nil
  end

  it 'has a standard error' do
    expect { raise KManager::Error, 'some message' }
      .to raise_error('some message')
  end
end
