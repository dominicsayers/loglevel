# frozen_string_literal: true

source 'https://rubygems.org'
gemspec

group :development do
  gem 'bundler'
  gem 'gem-release'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-rubocop'
end

group :test do
  gem 'mime-types', (RUBY_VERSION < '2' ? '< 3' : '> 0') # coveralls dependency
  gem 'listen', (RUBY_VERSION < '2' ? '< 3.1' : '> 0') # guard dependency
  gem 'coveralls'
  gem 'fuubar'
  gem 'rake' # Workaround for a bug in Rainbow 2.2.1 https://github.com/sickill/rainbow/issues/44
  gem 'rspec'
  gem 'rspec_junit_formatter'
  gem 'simplecov', '~> 0.13'
end
