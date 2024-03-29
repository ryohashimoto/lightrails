# frozen_string_literal: true

version = File.read(File.expand_path("../VERSION", __dir__)).strip
date = File.read(File.expand_path("../RELEASE_DATE", __dir__)).strip

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "actioninteractor"
  s.version     = version
  s.date        = date
  s.summary     = "Action Interactor provides a simple interface for performing operations (part of Lightrails)."
  s.description = "Action Interactor provides a simple interface for performing operations like Service Object / Command pattern."

  s.required_ruby_version     = ">= 2.7.0"
  s.required_rubygems_version = ">= 1.8.11"

  s.license       = "MIT"

  s.authors     = ["Ryo Hashimoto"]
  s.email       = "ryohashimoto@gmail.com"
  s.homepage    = "https://github.com/ryohashimoto/lightrails"

  s.files       = `git ls-files`.split($/)
  s.test_files  = s.files.grep(/^test/)

  s.add_dependency "bundler", ">= 1.3"
  s.add_development_dependency "rake", ">= 12.3.3"
  s.add_development_dependency "test-unit", ">= 3.3"
end
