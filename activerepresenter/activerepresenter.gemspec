# frozen_string_literal: true

version = File.read(File.expand_path("../LIGHTRAILS_VERSION", __dir__)).strip

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "activerepresenter"
  s.version     = version
  s.date        = "2018-10-03"
  s.summary     = "Active Representer provides model objects by decorating hash-like objects (part of Lightrails)."
  s.description = "Active Representer provides model objects for web applications by decorating hash-like objects."

  s.required_ruby_version     = ">= 2.2.2"
  s.required_rubygems_version = ">= 1.8.11"

  s.license       = "MIT"

  s.authors     = ["Ryo Hashimoto"]
  s.email       = "ryohashimoto@gmail.com"
  s.homepage    = "https://github.com/ryohashimoto/lightrails"

  s.files       = `git ls-files`.split($/)
  s.test_files  = s.files.grep(/^test/)

  s.add_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake", "~> 0"
end
