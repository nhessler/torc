# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'torc/version'

Gem::Specification.new do |spec|
  spec.name          = "torc"
  spec.version       = Torc::VERSION
  spec.authors       = ["Nathan Hessler"]
  spec.email         = ["xmilestegx@gmail.com"]

  spec.summary       = %q{A Tail Optimized Recursive Call Helper}
  spec.description   = %q{Not comfortable messing with the flags set in ruby to get Tail Optimized Recursion? Use this helper instead and never blow the stack}
  spec.homepage      = "https://github.com/nhessler/torc"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'binding_of_caller', '~> 0.7.2'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
