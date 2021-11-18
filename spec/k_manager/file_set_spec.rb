# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KManager::FileSet do
  around(:each) do |example|
    Dir.chdir("spec/samples") do
      example.run
    end
  end

  # https://bugs.ruby-lang.org/issues/17280
  #
  # There is two separate issues when looking at FNM_DOTMATCH
  # 1. When the recursive glob is used ("**/*"), then the same folder shows up under two paths, once in the parent directory and once in its own directory.
  #    - example: 
  #               .builder/config
  #               .builder/config/.
  # 2. When a non-recursive glob is used and the reference to the parent folder (..) shows up (this is always excluded in recursive mode, even without FNM_DOTMATCH).
  #    - example: 
  #               .builder/config/..
  #
  # The first issue we can solve by skipping the current directory entry if it is . and we are in recursive mode and the current path (parent directory) matches the previous entry in the resulting array. This approach works as glob uses a depth-first search and not a breadth-first search, as long as . is the first entry in the directory.
  # The second issue we can solve by not matching .. entry if the glob is magical == 2 (* sets that).
  let(:match_rules) {
    [
      { type: :parent_folder      , dot: true , tags: %i[                ], path: '..'},
      { type: :folder_dot         , dot: true , tags: %i[                ], path: '.'},
      { type: :folder             , dot: true , tags: %i[     builder    ], path: '.builder'},
      { type: :parent_folder      , dot: true , tags: %i[     builder    ], path: '.builder/..'},
      { type: :folder_dot         , dot: true , tags: %i[     builder    ], path: '.builder/.'},
      { type: :folder             , dot: true , tags: %i[     builder    ], path: '.builder/config'},
      { type: :parent_folder      , dot: true , tags: %i[     builder    ], path: '.builder/config/..'},
      { type: :folder_dot         , dot: true , tags: %i[     builder    ], path: '.builder/config/.'},
      { type: :file               , dot: true , tags: %i[ruby builder    ], path: '.builder/config/app_settings.rb'},
      { type: :file               , dot: true , tags: %i[ruby builder    ], path: '.builder/config/builder_config.rb'},
      { type: :folder             , dot: true , tags: %i[     builder    ], path: '.builder/data_files'},
      { type: :parent_folder      , dot: true , tags: %i[     builder    ], path: '.builder/data_files/..'},
      { type: :folder_dot         , dot: true , tags: %i[     builder    ], path: '.builder/data_files/.'},
      { type: :file               , dot: true , tags: %i[json builder    ], path: '.builder/data_files/PersonDetails.json'},
      { type: :file               , dot: true , tags: %i[csv  builder    ], path: '.builder/data_files/countries.csv'},
      { type: :file               , dot: true , tags: %i[yaml builder    ], path: '.builder/data_files/developers.yaml'},
      { type: :file               , dot: true , tags: %i[ruby builder    ], path: '.builder/data_files/dsl-1-key.rb'},
      { type: :file               , dot: true , tags: %i[ruby builder    ], path: '.builder/data_files/dsl-4-keys.rb'},
      { type: :file               , dot: true , tags: %i[ruby builder    ], path: '.builder/data_files/simple.rb'},
      { type: :file               , dot: true , tags: %i[txt  builder    ], path: '.builder/data_files/some-file.txt'},
      { type: :folder             , dot: true , tags: %i[txt  builder    ], path: '.builder/folder.txt'},
      { type: :parent_folder      , dot: true , tags: %i[     builder    ], path: '.builder/folder.txt/..'},
      { type: :folder_dot         , dot: true , tags: %i[     builder    ], path: '.builder/folder.txt/.'},
      { type: :file               , dot: true , tags: %i[txt  builder    ], path: '.builder/folder.txt/odd1.txt'},
      { type: :folder             , dot: true , tags: %i[     builder    ], path: '.builder/raw_data'},
      { type: :parent_folder      , dot: true , tags: %i[     builder    ], path: '.builder/raw_data/..'},
      { type: :folder_dot         , dot: true , tags: %i[     builder    ], path: '.builder/raw_data/.'},
      { type: :file               , dot: true , tags: %i[json builder    ], path: '.builder/raw_data/PersonDetails.json'},
      { type: :file               , dot: true , tags: %i[csv  builder    ], path: '.builder/raw_data/countries.csv'},
      { type: :folder             , dot: true , tags: %i[     builder    ], path: '.builder/raw_data/deprecated'},
      { type: :parent_folder      , dot: true , tags: %i[     builder    ], path: '.builder/raw_data/deprecated/..'},
      { type: :folder_dot         , dot: true , tags: %i[     builder    ], path: '.builder/raw_data/deprecated/.'},
      { type: :file               , dot: true , tags: %i[txt  builder    ], path: '.builder/raw_data/deprecated/some-other-file.txt'},
      { type: :file               , dot: true , tags: %i[yaml builder    ], path: '.builder/raw_data/developers.yaml'},
      { type: :file               , dot: true , tags: %i[txt  builder    ], path: '.builder/raw_data/some-file.txt'},
      { type: :file               , dot: true , tags: %i[ruby builder    ], path: '.builder/setup.rb'},
      { type: :folder             , dot: true , tags: %i[                ], path: '.templates'},
      { type: :parent_folder      , dot: true , tags: %i[                ], path: '.templates/..'},
      { type: :folder_dot         , dot: true , tags: %i[                ], path: '.templates/.'},
      { type: :file               , dot: true , tags: %i[cs   xmen       ], path: '.templates/sample-xmen.cs'},
      { type: :file               , dot: true , tags: %i[ruby ymen       ], path: '.templates/sample-ymen.rb'},
      { type: :file               , dot: true , tags: %i[cs   zmen       ], path: '.templates/sample-zmen.cs'},
      { type: :file               , dot: true , tags: %i[ruby zmen       ], path: '.templates/sample-zmen.rb'},
      { type: :folder             , dot: false, tags: %i[          target], path: 'target'},
      { type: :parent_folder      , dot: false, tags: %i[          target], path: 'target/..'},
      { type: :folder_dot         , dot: false, tags: %i[          target], path: 'target/.'},
      { type: :folder             , dot: true , tags: %i[          target], path: 'target/.dot_files'},
      { type: :parent_folder      , dot: true , tags: %i[          target], path: 'target/.dot_files/..'},
      { type: :folder_dot         , dot: true , tags: %i[          target], path: 'target/.dot_files/.'},
      { type: :file               , dot: true , tags: %i[          target], path: 'target/.dot_files/.one'},
      { type: :file               , dot: true , tags: %i[          target], path: 'target/.dot_files/.two'},
      { type: :folder             , dot: false, tags: %i[          target], path: 'target/deep'},
      { type: :parent_folder      , dot: false, tags: %i[          target], path: 'target/deep/..'},
      { type: :folder_dot         , dot: false, tags: %i[          target], path: 'target/deep/.'},
      { type: :folder             , dot: false, tags: %i[          target], path: 'target/deep/a'},
      { type: :parent_folder      , dot: false, tags: %i[          target], path: 'target/deep/a/..'},
      { type: :folder_dot         , dot: false, tags: %i[          target], path: 'target/deep/a/.'},
      { type: :folder             , dot: false, tags: %i[          target], path: 'target/deep/a/b'},
      { type: :parent_folder      , dot: false, tags: %i[          target], path: 'target/deep/a/b/..'},
      { type: :folder_dot         , dot: false, tags: %i[          target], path: 'target/deep/a/b/.'},
      { type: :folder             , dot: false, tags: %i[          target], path: 'target/deep/a/b/c'},
      { type: :parent_folder      , dot: false, tags: %i[          target], path: 'target/deep/a/b/c/..'},
      { type: :folder_dot         , dot: false, tags: %i[          target], path: 'target/deep/a/b/c/.'},
      { type: :folder             , dot: false, tags: %i[          target], path: 'target/deep/a/b/c/d'},
      { type: :parent_folder      , dot: false, tags: %i[          target], path: 'target/deep/a/b/c/d/..'},
      { type: :folder_dot         , dot: false, tags: %i[          target], path: 'target/deep/a/b/c/d/.'},
      { type: :folder             , dot: true , tags: %i[          target], path: 'target/deep/a/b/c/d/.dot_files'},
      { type: :parent_folder      , dot: true , tags: %i[          target], path: 'target/deep/a/b/c/d/.dot_files/..'},
      { type: :folder_dot         , dot: true , tags: %i[          target], path: 'target/deep/a/b/c/d/.dot_files/.'},
      { type: :file               , dot: true , tags: %i[          target], path: 'target/deep/a/b/c/d/.dot_files/.one'},
      { type: :file               , dot: true , tags: %i[          target], path: 'target/deep/a/b/c/d/.dot_files/.two'},
      { type: :folder             , dot: false, tags: %i[          target], path: 'target/deep/a/b/c/d/e'},
      { type: :parent_folder      , dot: false, tags: %i[          target], path: 'target/deep/a/b/c/d/e/..'},
      { type: :folder_dot         , dot: false, tags: %i[          target], path: 'target/deep/a/b/c/d/e/.'},
      { type: :file               , dot: false, tags: %i[txt  xmen target], path: 'target/deep/a/b/c/d/e/xmen.txt'},
      { type: :file               , dot: false, tags: %i[txt       target], path: 'target/look-at-my-eyes.txt'},
      { type: :file               , dot: false, tags: %i[txt       target], path: 'target/move-along.txt'},
      { type: :folder             , dot: false, tags: %i[          target], path: 'target/unwatched'},
      { type: :parent_folder      , dot: false, tags: %i[          target], path: 'target/unwatched/..'},
      { type: :folder_dot         , dot: false, tags: %i[          target], path: 'target/unwatched/.'},
      { type: :file               , dot: false, tags: %i[txt       target], path: 'target/unwatched/nothing-to-see.txt'},
      { type: :file               , dot: false, tags: %i[txt       target], path: 'target/unwatched/what-you-looking-at.txt'},
      { type: :folder             , dot: false, tags: %i[          target], path: 'target/watched'},
      { type: :parent_folder      , dot: false, tags: %i[          target], path: 'target/watched/..'},
      { type: :folder_dot         , dot: false, tags: %i[          target], path: 'target/watched/.'},
      { type: :file               , dot: false, tags: %i[txt       target], path: 'target/watched/look-at-me.txt'},
      { type: :file               , dot: false, tags: %i[txt       target], path: 'target/watched/over-here.txt' }
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

    let(:match_paths)  { match(types: %i[folder file folder_dot]) }
    let(:flags) { File::FNM_DOTMATCH }
    let(:glob)  { '.builder/config/*' }

    describe '.path_entries' do
      subject { instance.path_entries }

      # it { subject.each { |pe| pe.debug } }
      it { is_expected.to have_attributes(length: 4) }
    end

    describe '.relative_paths' do
      subject { instance.relative_paths }

      it do
        is_expected
          .to have_attributes(length: 4)
          .and include(
            '.builder/config/..',
            '.builder/config/.',
            '.builder/config/app_settings.rb',
            '.builder/config/builder_config.rb'
          )
      end
    end

    describe '.absolute_paths' do
      subject { instance.absolute_paths }

      it do
        is_expected
          .to  have_attributes(length: 4)
          .and include(
            File.expand_path('.builder'),
            File.expand_path('.builder/config'),
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
      before { 
        instance.glob(glob, exclude: exclude, flags: flags, use_defaults: use_defaults)
        File.write(File.expand_path('../b2.txt'), (['subject'] + subject).join("\n"))
      }

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

      context 'include deep folder / file pattern variations' do
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

          context 'and folder exclusion (via default pattern)' do
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
          let(:match_paths)  { match(types: %i[file folder folder_dot]) }
          let(:flags) { File::FNM_DOTMATCH }
      
          it { is_expected.to have_attributes(length: match_paths.length).and eq(match_paths) }

          context 'and folder exclusion (via default pattern)' do
            let(:use_defaults) { true }
            let(:match_paths)  { match(types: %i[file]) }
        
            it { is_expected.to have_attributes(length: match_paths.length).and eq(match_paths)}
          end

          context 'with ignore folders - current' do
            let(:exclude) { KManager::FileSet::IGNORE_LAMBDAS[:folder_current] }
            let(:match_paths)  { match(types: %i[file folder_dot]) }

            it { is_expected.to have_attributes(length: match_paths.length).and eq(match_paths)}
          end

          context 'with ignore folders - current_dot' do
            let(:exclude) { KManager::FileSet::IGNORE_LAMBDAS[:folder_current_dot] }
            let(:match_paths)  { match(types: %i[file folder]) }
      
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

          it { is_expected.to have_attributes(length: match_paths.length).and eq(match_paths)}

          context 'and exclude current folders (this is a default pattern)' do
            let(:use_defaults) { true }
            let(:match_paths)  { match(types: %i[file]) }

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

          context 'and exclude current folders (this is a default pattern)' do
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
