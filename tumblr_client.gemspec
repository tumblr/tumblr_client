# encoding: utf-8
require File.join(File.dirname(__FILE__), 'lib/tumblr/version')

Gem::Specification.new do |gem|
  gem.required_ruby_version = ">= 1.9.2"
  gem.add_dependency 'faraday', '~> 0.9.0'
  gem.add_dependency 'faraday_middleware', '~> 0.9'
  gem.add_dependency 'json', '~> 1.8'
  gem.add_dependency 'simple_oauth', '~> 0.3'
  gem.add_dependency 'oauth', '~> 0.5'
  gem.add_dependency 'mime-types', '~> 2.99'
  gem.add_development_dependency 'rake', '~> 10.5'
  gem.add_development_dependency 'rspec', '~> 3.5'
  gem.add_development_dependency 'webmock', '~> 1.24'
  gem.add_development_dependency 'simplecov', '~> 0.12'
  gem.authors = ['John Bunting', 'John Crepezzi']
  gem.description = %q{A Ruby wrapper for the Tumblr v2 API}
  gem.email = ['codingjester@gmail.com', 'john@crepezzi.com']
  gem.executables = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f)}
  gem.files = `git ls-files`.split("\n")
  gem.homepage = "http://github.com/tumblr/tumblr_client"
  gem.license = "Apache"
  gem.name = "tumblr_client"
  gem.require_paths = ["lib"]
  gem.summary = %q{Tumblr API wrapper}
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.version = Tumblr::VERSION
end
