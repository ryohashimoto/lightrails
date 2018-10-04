# frozen_string_literal: true

version = File.read(File.expand_path("LIGHTRAILS_VERSION", __dir__)).strip

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "lightrails"
  s.version     = version
  s.date        = "2018-10-04"
  s.summary     = "Utility library for Ruby on Rails"
  s.description = "Lightrails is a utility library including ActionInteractor, ActiveRepresenter etc. for Ruby on Rails."

  s.required_ruby_version     = ">= 2.2.2"
  s.required_rubygems_version = ">= 1.8.11"

  s.license       = "MIT"

  s.authors     = ["Ryo Hashimoto"]
  s.email       = "ryohashimoto@gmail.com"
  s.homepage    = "https://github.com/ryohashimoto/lightrails"

  s.files       = ["README.md"]

  s.add_dependency "rails", ">= 5.1"
  s.add_dependency "actioninteractor",  version
  s.add_dependency "activerepresenter", version

  s.add_dependency "bundler",         ">= 1.3.0"
end
