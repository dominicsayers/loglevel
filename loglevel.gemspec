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
  spec.description = 'A simple gem to interact with Mailchimp through their API v3'
  spec.summary = 'Example: mailchimp.lists("My first list").member("ann@example.com")'
  spec.homepage = 'https://github.com/dominicsayers/loglevel'
  spec.license = 'MIT'

  spec.files = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables = spec.files.grep(%r{^bin\/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features|coverage|script)\/})
  spec.require_paths = ['lib']
end
