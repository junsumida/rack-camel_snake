# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "rack-camel_snake"
  spec.version       = '0.0.3'
  spec.authors       = ["junsumida", "rnakano", "luckypool"]
  spec.email         = ["jun.sumida@mixi.co.jp"]
  spec.summary       = %q{Rack middleware to exchange camel case and snake case}
  spec.description   = %q{You can easily convert keys in a json from camelCase into snake_case, and vice versa.}
  spec.homepage      = "https://github.com/junsumida/camel-snake-exchanger"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "json"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rack"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "sinatra"
end
