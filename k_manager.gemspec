# frozen_string_literal: true

require_relative 'lib/k_manager/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version  = '>= 2.5'
  spec.name                   = 'k_manager'
  spec.version                = KManager::VERSION
  spec.authors                = ['David Cruwys']
  spec.email                  = ['david@ideasmen.com.au']

  spec.summary                = 'K Manager provides a managed host for documents, resources and code generator execution'
  spec.description            = <<-TEXT
    K Manager provides a managed host for documents, resources and code generator execution
  TEXT
  spec.homepage               = 'http://appydave.com/gems/k-manager'
  spec.license                = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.' unless spec.respond_to?(:metadata)

  # spec.metadata['allowed_push_host'] = "Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri']           = spec.homepage
  spec.metadata['source_code_uri']        = 'https://github.com/klueless-io/k_manager'
  spec.metadata['changelog_uri']          = 'https://github.com/klueless-io/k_manager/commits/master'
  spec.metadata['rubygems_mfa_required']  = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the RubyGem files that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  # spec.extensions    = ['ext/k_manager/extconf.rb']

  spec.add_dependency 'cmdlet', '~> 0'
  spec.add_dependency 'drawio_dsl', '~> 0.1'
  spec.add_dependency 'dry-struct', '~> 1'
  spec.add_dependency 'filewatcher', '~> 2.1.0'
  spec.add_dependency 'k_builder', '~> 0.0.0'
  spec.add_dependency 'k_director', '~> 0.1'
  spec.add_dependency 'k_doc', '~> 0.0.0'
  spec.add_dependency 'k_domain', '~> 0.0.0'
  spec.add_dependency 'k_ext-github', '~> 0.0.0'
  spec.add_dependency 'k_fileset', '~> 0.0.0'
  spec.add_dependency 'k_log', '~> 0.0.0'

  # spec.add_dependency 'k_type'                , '~> 0.0.0'
  # spec.add_dependency 'k_util'                , '~> 0.0.0'
  spec.add_dependency 'dry-cli', '~> 1.0.0'
  spec.add_dependency 'tailwind_dsl'
end
