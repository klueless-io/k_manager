# frozen_string_literal: true

require 'spec_helper'

      #   # let(:glob)  { '{.[^\.]*,*}/**/*' }
      #   let(:glob)  { '{.[^\.]*,*,**}/**/{.[^\.]*,*,**}/{.[^\.]*,*,**}' }
      #   # let(:glob)  { '**/*' }
      #   # let(:glob)  { '**/*' }
      #   let(:exclude) { /\.one|b[12].txt/ }

RSpec.describe KManager::FileSet do
  around(:each) do |example|
    Dir.chdir("spec/samples") do
      example.run
    end
  end

  let(:match_rules) {
    [
      { type: :dot_fold, dot: true , tags: %i[                ], path: '.'},
      { type: :folder  , dot: true , tags: %i[     builder    ], path: '.builder'},
      { type: :dot_fold, dot: true , tags: %i[     builder    ], path: '.builder/.'},
      { type: :folder  , dot: true , tags: %i[     builder    ], path: '.builder/config'},
      { type: :dot_fold, dot: true , tags: %i[     builder    ], path: '.builder/config/.'},
      { type: :file    , dot: true , tags: %i[ruby builder    ], path: '.builder/config/app_settings.rb'},
      { type: :file    , dot: true , tags: %i[ruby builder    ], path: '.builder/config/builder_config.rb'},
      { type: :folder  , dot: true , tags: %i[     builder    ], path: '.builder/data_files'},
      { type: :dot_fold, dot: true , tags: %i[     builder    ], path: '.builder/data_files/.'},
      { type: :file    , dot: true , tags: %i[json builder    ], path: '.builder/data_files/PersonDetails.json'},
      { type: :file    , dot: true , tags: %i[csv  builder    ], path: '.builder/data_files/countries.csv'},
      { type: :file    , dot: true , tags: %i[yaml builder    ], path: '.builder/data_files/developers.yaml'},
      { type: :file    , dot: true , tags: %i[ruby builder    ], path: '.builder/data_files/dsl-1-key.rb'},
      { type: :file    , dot: true , tags: %i[ruby builder    ], path: '.builder/data_files/dsl-4-keys.rb'},
      { type: :file    , dot: true , tags: %i[ruby builder    ], path: '.builder/data_files/simple.rb'},
      { type: :file    , dot: true , tags: %i[txt  builder    ], path: '.builder/data_files/some-file.txt'},
      { type: :folder  , dot: true , tags: %i[txt  builder    ], path: '.builder/folder.txt'},
      { type: :dot_fold, dot: true , tags: %i[     builder    ], path: '.builder/folder.txt/.'},
      { type: :file    , dot: true , tags: %i[txt  builder    ], path: '.builder/folder.txt/odd1.txt'},
      { type: :folder  , dot: true , tags: %i[     builder    ], path: '.builder/raw_data'},
      { type: :dot_fold, dot: true , tags: %i[     builder    ], path: '.builder/raw_data/.'},
      { type: :file    , dot: true , tags: %i[json builder    ], path: '.builder/raw_data/PersonDetails.json'},
      { type: :file    , dot: true , tags: %i[csv  builder    ], path: '.builder/raw_data/countries.csv'},
      { type: :folder  , dot: true , tags: %i[     builder    ], path: '.builder/raw_data/deprecated'},
      { type: :dot_fold, dot: true , tags: %i[     builder    ], path: '.builder/raw_data/deprecated/.'},
      { type: :file    , dot: true , tags: %i[txt  builder    ], path: '.builder/raw_data/deprecated/some-other-file.txt'},
      { type: :file    , dot: true , tags: %i[yaml builder    ], path: '.builder/raw_data/developers.yaml'},
      { type: :file    , dot: true , tags: %i[txt  builder    ], path: '.builder/raw_data/some-file.txt'},
      { type: :file    , dot: true , tags: %i[ruby builder    ], path: '.builder/setup.rb'},
      { type: :folder  , dot: true , tags: %i[                ], path: '.templates'},
      { type: :dot_fold, dot: true , tags: %i[                ], path: '.templates/.'},
      { type: :file    , dot: true , tags: %i[cs   xmen       ], path: '.templates/sample-xmen.cs'},
      { type: :file    , dot: true , tags: %i[ruby ymen       ], path: '.templates/sample-ymen.rb'},
      { type: :file    , dot: true , tags: %i[cs   zmen       ], path: '.templates/sample-zmen.cs'},
      { type: :file    , dot: true , tags: %i[ruby zmen       ], path: '.templates/sample-zmen.rb'},
      { type: :folder  , dot: false, tags: %i[          target], path: 'target'},
      { type: :dot_fold, dot: false, tags: %i[          target], path: 'target/.'},
      { type: :folder  , dot: true , tags: %i[          target], path: 'target/.dot_files'},
      { type: :dot_fold, dot: true , tags: %i[          target], path: 'target/.dot_files/.'},
      { type: :file    , dot: true , tags: %i[          target], path: 'target/.dot_files/.one'},
      { type: :file    , dot: true , tags: %i[          target], path: 'target/.dot_files/.two'},
      { type: :folder  , dot: false, tags: %i[          target], path: 'target/deep'},
      { type: :dot_fold, dot: false, tags: %i[          target], path: 'target/deep/.'},
      { type: :folder  , dot: false, tags: %i[          target], path: 'target/deep/a'},
      { type: :dot_fold, dot: false, tags: %i[          target], path: 'target/deep/a/.'},
      { type: :folder  , dot: false, tags: %i[          target], path: 'target/deep/a/b'},
      { type: :dot_fold, dot: false, tags: %i[          target], path: 'target/deep/a/b/.'},
      { type: :folder  , dot: false, tags: %i[          target], path: 'target/deep/a/b/c'},
      { type: :dot_fold, dot: false, tags: %i[          target], path: 'target/deep/a/b/c/.'},
      { type: :folder  , dot: false, tags: %i[          target], path: 'target/deep/a/b/c/d'},
      { type: :dot_fold, dot: false, tags: %i[          target], path: 'target/deep/a/b/c/d/.'},
      { type: :folder  , dot: true , tags: %i[          target], path: 'target/deep/a/b/c/d/.dot_files'},
      { type: :dot_fold, dot: true , tags: %i[          target], path: 'target/deep/a/b/c/d/.dot_files/.'},
      { type: :file    , dot: true , tags: %i[          target], path: 'target/deep/a/b/c/d/.dot_files/.one'},
      { type: :file    , dot: true , tags: %i[          target], path: 'target/deep/a/b/c/d/.dot_files/.two'},
      { type: :folder  , dot: false, tags: %i[          target], path: 'target/deep/a/b/c/d/e'},
      { type: :dot_fold, dot: false, tags: %i[          target], path: 'target/deep/a/b/c/d/e/.'},
      { type: :file    , dot: false, tags: %i[txt  xmen target], path: 'target/deep/a/b/c/d/e/xmen.txt'},
      { type: :file    , dot: false, tags: %i[txt       target], path: 'target/look-at-my-eyes.txt'},
      { type: :file    , dot: false, tags: %i[txt       target], path: 'target/move-along.txt'},
      { type: :folder  , dot: false, tags: %i[          target], path: 'target/unwatched'},
      { type: :dot_fold, dot: false, tags: %i[          target], path: 'target/unwatched/.'},
      { type: :file    , dot: false, tags: %i[txt       target], path: 'target/unwatched/nothing-to-see.txt'},
      { type: :file    , dot: false, tags: %i[txt       target], path: 'target/unwatched/what-you-looking-at.txt'},
      { type: :folder  , dot: false, tags: %i[          target], path: 'target/watched'},
      { type: :dot_fold, dot: false, tags: %i[          target], path: 'target/watched/.'},
      { type: :file    , dot: false, tags: %i[txt       target], path: 'target/watched/look-at-me.txt'},
      { type: :file    , dot: false, tags: %i[txt       target], path: 'target/watched/over-here.txt' }
    ]
  }

  let(:instance) { described_class.new }
  let(:glob)  { '' }
  let(:exclude) { nil }
  let(:flags) { nil }
  let(:use_defaults) { false }

  describe '#initialize' do
    # subject { instance }
  end

  describe '.pwd' do
    subject { instance.pwd }
  
    it { is_expected.to eq(Dir.pwd) }
  end

  describe '.whitelist' do
    subject { instance.whitelist.glob_entries.length }

    context 'when #glob simple glob' do
      let(:glob)  { '.templates/*' }
      before { instance.glob(glob, exclude: exclude, flags: flags, use_defaults: use_defaults) }
    
      it { is_expected.to eq(1) }
    end
  end

  describe '.path_entries' do
    before { instance.glob(glob, exclude: exclude, flags: flags, use_defaults: use_defaults) }

    let(:glob)  { '.builder/config/*' }
    let(:flags) { File::FNM_DOTMATCH }

    fdescribe '.path_entries' do
      subject { instance.path_entries }

      it do
        binding.pry
        puts subject
        # is_expected
        #   .to have_attributes(length: 2)
        #   .and include(
        #     '.builder/config/app_settings.rb',
        #     '.builder/config/builder_config.rb'
        #   )
      end
    end


    describe '.relative_paths' do
      subject { instance.relative_paths }

      it do
        puts subject
        is_expected
          .to have_attributes(length: 2)
          .and include(
            '.builder/config/app_settings.rb',
            '.builder/config/builder_config.rb'
          )
      end
    end

    describe '.absolute_paths' do
      subject { instance.absolute_paths }

      it do
        puts subject
        is_expected
          .to have_attributes(length: 2)
          .and include(
            File.expand_path('.builder/config/app_settings.rb'),
            File.expand_path('.builder/config/builder_config.rb')
          )
      end
    end
  end

  describe '#remove' do
    subject { instance.relative_paths }

    before do
      instance.glob(glob, exclude: exclude, flags: flags, use_defaults: use_defaults)
    end

    let(:glob)  { '.templates/*' }

    it do
      is_expected
        .to have_attributes(length: 4)
        .and include('.templates/sample-zmen.cs')
    end

    context 'remove .templates/sample-zmen.cs' do
      before { instance.remove('.templates/sample-zmen.cs') }

      it { is_expected.to have_attributes(length: 3) }
      it { is_expected.not_to include('.templates/sample-zmen.cs') }
    end
  end

  describe '#clear' do
    subject { instance.length }

    before do
      instance.glob(glob, exclude: exclude, flags: flags, use_defaults: use_defaults)
    end

    let(:glob)  { '.templates/*' }

    it { is_expected.to eq(4) }
    
    context 'clear .templates/sample-zmen.cs' do
      before { instance.clear }

      it { is_expected.to eq(0) }
    end
  end

  # describe '#add' do
  #   subject { instance.files }

  #   before do
  #     instance.glob(glob, exclude: exclude, flags: flags, use_defaults: use_defaults)
  #   end

  #   let(:glob)  { '.templates/*.rb' }

  #   it do
  #     is_expected
  #       .to have_attributes(length: 2)
  #       .and include('.templates/sample-ymen.rb', '.templates/sample-zmen.rb')
  #   end

  #   context 'when file matches inclusion glob' do
  #     before { instance.add(new_file) }
  #     context 'add .templates/sample-xmen.rb' do
  #       let(:new_file) { File.expand_path('.templates/sample-xmen.rb') }

  #       it { is_expected.to have_attributes(length: 3) }
  #       it { is_expected.not_to include(new_file) }
  #     end
  #   end
  # end

  describe '#glob' do
    subject { instance.relative_paths }
  
    it { is_expected.to be_empty }
    
    context 'simple scenarios' do
      before { instance.glob(glob, exclude: exclude, flags: flags, use_defaults: use_defaults) }

      context 'when .templates/*' do
        let(:glob)  { '.templates/*' }

        it do
          is_expected.to include(
            '.templates/sample-xmen.cs',
            '.templates/sample-ymen.rb',
            '.templates/sample-zmen.cs',
            '.templates/sample-zmen.rb'
          )
        end
                
        context 'when Glob based excludes' do
          context '.t*/*zmen.*' do
            let(:exclude) { '.t*/*zmen.*' }
  
            it do
              is_expected.not_to include(
                '.templates/sample-zmen.cs',
                '.templates/sample-zmen.rb'
              )
            end
          end
  
          context '[".t*/*zmen.*", ".t*/*xmen.*"]' do
            let(:exclude) { ['.t*/*zmen.*', '.t*/*xmen.*'] }
  
            it do
              is_expected.not_to include(
                '.templates/sample-xmen.cs',
                '.templates/sample-zmen.cs',
                '.templates/sample-zmen.rb'
              )
            end
          end
        end

        context 'when Regexp based excludes' do
          context '/[xy]men/' do
            let(:exclude) { /[xy]men/ }
  
            it do
              is_expected.not_to include(
                '.templates/sample-xmen.cs',
                '.templates/sample-ymen.rb'
              )
            end
          end

          context '/[xy]men/ and /\.cs/' do
            let(:exclude) { [/[xy]men/, /\.cs/] }
  
            it do
              is_expected.not_to include(
                '.templates/sample-xmen.cs',
                '.templates/sample-ymen.rb',
                '.templates/sample-zmen.cs'
              )
            end
          end
        end

        context 'when Regexp and Glob based excludes' do
          context "/[xy]men/, '.*/*.cs'" do
            let(:exclude) { [/[xy]men/, '.*/*.cs'] }
  
            it do
              is_expected.not_to include(
                '.templates/sample-xmen.cs',
                '.templates/sample-ymen.rb',
                '.templates/sample-zmen.cs'
              )
            end
          end
        end

        context 'when incompatible exclusion data types' do
          # These are skipped
          let(:exclude) { [123, true, 1232.123] }
          it do
            is_expected.to include(
              '.templates/sample-xmen.cs',
              '.templates/sample-ymen.rb',
              '.templates/sample-zmen.cs',
              '.templates/sample-zmen.rb'
            )
          end
        end
      end
    end

    context 'specific scenarios' do
      # before { instance.glob(glob, exclude: exclude, flags: flags, use_defaults: use_defaults) }
      before { 
        instance.glob(glob, exclude: exclude, flags: flags, use_defaults: use_defaults)
        File.write(File.expand_path('../b2.txt'), (['subject'] + subject).join("\n"))
        File.write(File.expand_path('../b3.txt'), (['match_paths'] + match_paths).join("\n"))
      }

      context 'include all folder / all file pattern variations' do
        # Examples:
        # -------------------------------
        # target
        # target/look-at-my-eyes.txt
        # target/move-along.txt
        # target/unwatched
        # target/unwatched/nothing-to-see.txt
        # target/unwatched/what-you-looking-at.txt
        context 'when deep folder/all file with FNM_PATHNAME (no .DOT files or .DOT folders or folder/.DOTs)' do
          let(:glob)  { '**/*' }
          let(:match_paths)  { match(types: %i[folder file], dot: false) }
          let(:flags) { File::FNM_PATHNAME }
      
          it { is_expected.to have_attributes(length: match_paths.length).and eq(match_paths)}

          context 'and exclude folders (this is a default pattern)' do
            let(:use_defaults) { true }
            let(:match_paths)  { match(types: %i[file], dot: false) }
            # let(:exclude) { lambda { |path| File.directory?(path) } }

            it { is_expected.to have_attributes(length: match_paths.length).and eq(match_paths)}
          end
        end

        # Examples:
        # -------------------------------
        # .builder/config
        # .builder/config/.
        # .builder/config/app_settings.rb
        # target
        # target/.
        # target/.dot_files
        context 'when deep folder/all file and FNM_DOTMATCH (includes .DOT files, .DOT folders and folder/.DOTs)' do
          let(:glob)  { '**/*' }
          # let(:match_paths)  { match(types: %i[folder file dot_fold]) }
          let(:match_paths)  { match(types: %i[folder file dot_fold]) }
          let(:flags) { File::FNM_DOTMATCH }
      
          it { is_expected.to have_attributes(length: match_paths.length).and eq(match_paths) }

          context 'and exclude folders (this is a default pattern)' do
            let(:use_defaults) { true }
            let(:match_paths)  { match(types: %i[file]) }
            # let(:exclude) { lambda { |path| File.directory?(path) } }
        
            it { is_expected.to have_attributes(length: match_paths.length).and eq(match_paths)}
          end

          context 'and file contains xmen' do
            let(:match_paths)  { match(types: %i[file], include_tags: %i[xmen]) }
            let(:exclude) do
              lambda do |path| 
                is_file = !File.directory?(path)
                has_xmen_content = is_file && File.read(path).include?('xmen')
                !has_xmen_content
              end
            end

            it { is_expected.to have_attributes(length: match_paths.length).and eq(match_paths)}
          end
        end

        # Examples:
        # -------------------------------
        # .builder/config
        # .builder/config/app_settings.rb
        # target
        # target/.dot_files
        context 'when deep folder/all file (includes .DOT files, .DOT folders) but NOT (folder/.DOTs)' do
          let(:glob) { '{.[^\.]*,*,**}/**/{.[^\.]*,**}/{.[^\.]*,*,**}' }
          let(:match_paths)  { match(types: %i[folder file]) }
          # { type: :file    , dot: true , tags: %i[txt  builder    ], path: '.builder/data_files/some-file.txt'},
          # { type: :folder  , dot: true , tags: %i[txt  builder    ], path: '.builder/folder.txt'},
          # { type: :dot_fold, dot: true , tags: %i[     builder    ], path: '.builder/folder.txt/.'},
          # { type: :file    , dot: true , tags: %i[txt  builder    ], path: '.builder/folder.txt/odd1.txt'},
          # { type: :folder  , dot: true , tags: %i[     builder    ], path: '.builder/raw_data'},
    
          it { is_expected.to have_attributes(length: match_paths.length).and eq(match_paths)}

          context 'and exclude folders (this is a default pattern)' do
            let(:use_defaults) { true }
            let(:match_paths)  { match(types: %i[file]) }
            # let(:exclude) { lambda { |path| File.directory?(path) } }
        
            it { is_expected.to have_attributes(length: match_paths.length).and eq(match_paths)}
          end
        end
      end

      context 'include all folder / file pattern variations' do
        # Examples:
        # -------------------------------
        context 'when deep folder/*.txt file with FNM_PATHNAME (no .DOT files or .DOT folders or folder/.DOTs)' do
          let(:glob)  { '**/*.txt' }
          let(:match_paths)  { match(types: %i[file], dot: false, include_tags: %i[txt]) }
          let(:flags) { File::FNM_PATHNAME }
      
          it { is_expected.to have_attributes(length: match_paths.length).and eq(match_paths)}
        end

        context 'when deep folder/*.txt file with FNM_DOTMATCH (includes .DOT files, .DOT folders and folder/.DOTs)' do
          let(:glob)  { '**/*.txt' }
          let(:match_paths)  { match(types: %i[folder file], include_tags: %i[txt]) }
          let(:flags) { File::FNM_DOTMATCH }
      
          it { is_expected.to have_attributes(length: match_paths.length).and eq(match_paths)}

          context 'and exclude folders (this is a default pattern)' do
            let(:use_defaults) { true }
            let(:match_paths)  { match(types: %i[file], include_tags: %i[txt]) }
            # let(:exclude) { lambda { |path| File.directory?(path) } }
        
            it { is_expected.to have_attributes(length: match_paths.length).and eq(match_paths)}
          end
        end
      end
    end

    context 'advanced scenarios' do
      context 'when deep folder/all file with FNM_PATHNAME (no .DOT files or .DOT folders or folder/.DOTs)' do
        before {
          instance.glob('.builder/**/*.rb')
          instance.glob('target/**/*.txt', exclude: ['target/unwatched*', /move-along/])
          instance.glob('.templates/sample-{y,z}men.*')
          # instance.glob('.builder/**/*.rb', exclude: exclude, flags: flags, use_defaults: use_defaults)

          File.write(File.expand_path('../b2.txt'), (['subject'] + subject).join("\n"))
          File.write(File.expand_path('../b3.txt'), (['match_paths'] + match_paths).join("\n"))
        }
        let(:match_paths) do
          match(types: %i[file], include_tags: %i[ruby builder]) + 
          match(types: %i[file], include_tags: %i[ymen]) + 
          match(types: %i[file], include_tags: %i[zmen]) + 
          match(types: %i[file], include_tags: %i[txt target]).reject { |p| p.include?('unwatched') || p.include?('move-along') }
        end

        it { is_expected.to have_attributes(length: match_paths.length).and eq(match_paths)}
      end
    end
  end

  def match(type: nil, types: [], dot: nil, include_tags: [])
    filter_rules = match_rules
    filter_rules = filter_rules.select { |rule| types.include?(rule[:type]) } if types.length > 0
    filter_rules = filter_rules.select { |rule| rule[:type] == type } unless type.nil?
    filter_rules = filter_rules.select { |rule| rule[:dot] == dot   } unless dot.nil?
    filter_rules = filter_rules.select { |rule| include_tags.all? { |tag| rule[:tags].include?(tag) } } if include_tags.length > 0
    filter_rules.map { |rule| rule[:path] }.sort
  end
end
