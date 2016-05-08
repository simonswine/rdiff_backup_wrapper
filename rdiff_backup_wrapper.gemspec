# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rdiff_backup_wrapper/version'

Gem::Specification.new do |spec|
  spec.name          = "rdiff_backup_wrapper"
  spec.version       = RdiffBackupWrapper::VERSION
  spec.authors       = ["Christian Simon"]
  spec.email         = ["simon@swine.de"]

  spec.summary       = %q{rdiff-backup wrapper}
  spec.description   = %q{rdiff-backup wrapper}
  spec.homepage      = "https://github.com/simonswine/rdiff_backup_wrapper"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
