# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'geo_db/version'

Gem::Specification.new do |gem|
  gem.name          = "geo_db"
  gem.version       = GeoDB::VERSION
  gem.authors       = ["Alex Coles"]
  gem.email         = ["alex@alexbcoles.com"]
  gem.description   = %q{}
  gem.summary       = %q{}
  gem.homepage      = 'https://github.com/myabc/TODO'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency('do_mysql', '~> 0.10.0')

  gem.add_development_dependency('rspec', '~> 2.12.0')
end
