# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KManager::Whitelist do
  subject { instance }

  let(:pwd) { Dir.pwd }

  let(:instance) { described_class.new }

  describe '#initialize' do

    context '.glob_entries' do
      subject { instance.glob_entries }
    
      it { is_expected.to be_empty }

      context 'when one simple glob' do
        before { instance.add('xyz/**/*') }

        it do
          is_expected
            .to  have_attributes(length: 1)
            .and include(have_attributes(glob: 'xyz/**/*', path: pwd, exclusions: []))
        end

        context 'with exclusions' do
          before { instance.add('xyz/**/*', ['*.wtf', /^bob.*/]) }
  
          it do
            is_expected
              .to  have_attributes(length: 1)
              .and include(have_attributes(glob: 'xyz/**/*', path: pwd, exclusions: ['*.wtf', /^bob.*/]))
          end
        end
      end

      context "when two globs denormalize to the same glob" do
        before do
          instance
            .add('xyz/**/*')
            .add('xyz/abc/../**/*')
        end

        it do
          is_expected
            .to  have_attributes(length: 1)
            .and include(have_attributes(glob: 'xyz/**/*', path: pwd, exclusions: []))
        end

        context 'with exclusions (duplicates and new)' do
          before do
            instance
              .add('xyz/**/*'           , ['*.wtf', /^bob.*/])
              .add('xyz/abc/../**/*'    , ['*.wtf', '*.rofl'])
          end
  
          it do
            is_expected
              .to  have_attributes(length: 1)
              .and include(have_attributes(glob: 'xyz/**/*', path: pwd, exclusions: ['*.wtf', /^bob.*/, '*.rofl']))
          end
        end
      end

      context "when two globs separate globs" do
        before { instance.add('xyz/**/*').add('abc/**/*') }

        it do
          is_expected
            .to  have_attributes(length: 2)
            .and include(have_attributes(glob: 'xyz/**/*', path: pwd, exclusions: []))
            .and include(have_attributes(glob: 'abc/**/*', path: pwd, exclusions: []))
        end

        context 'with exclusions' do
          before do
            instance
              .add('xyz/**/*'           , ['*.wtf', /^bob.*/])
              .add('abc/**/*'           , ['*.rofl'])
          end
  
          it do
            is_expected
              .to  have_attributes(length: 2)
              .and include(have_attributes(glob: 'xyz/**/*', path: pwd, exclusions: ['*.wtf', /^bob.*/]))
              .and include(have_attributes(glob: 'abc/**/*', path: pwd, exclusions: ['*.rofl']))
          end
        end
      end
    end
  end
end
