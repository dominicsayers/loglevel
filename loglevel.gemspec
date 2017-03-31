# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'loglevel/version'

Gem::Specification.new do |spec|
  spec.name = 'loglevel'
  spec.version = Loglevel::VERSION
  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 2.0.0'
  spec.authors = ['Dominic Sayers']
  spec.email = ['dominic@sayers.cc']
  spec.description = 'A simple gem to control logging at runtime with an environment variable'
  spec.summary = 'Example: LOGLEVEL=WARN rails server'
  spec.homepage = 'https://github.com/dominicsayers/loglevel'
  spec.license = 'MIT'

  spec.files = `git ls-files`.split($INPUT_RECORD_SEPARATOR).reject { |f| f =~ %r{^spec/} }
  spec.executables = spec.files.grep(%r{^bin\/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features|coverage|script)/})
  spec.require_paths = ['lib']
end
