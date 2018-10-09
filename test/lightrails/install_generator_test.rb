require "test_helper"
require "generators/lightrails/install_generator"

module Lightrails
  class InstallGeneratorTest < ::Rails::Generators::TestCase
    tests Lightrails::Generators::InstallGenerator
    destination File.expand_path('../../tmp', __FILE__)
    setup :prepare_destination
    teardown { rm_rf(destination_root) }

    test "generates initializer for lightrails" do
      run_generator
      assert_file "config/initializers/lightrails.rb"
    end

    test "generates application facade" do
      run_generator
      assert_file "app/facades/application_facade.rb"
    end

    test "generates application interactor" do
      run_generator
      assert_file "app/interactors/application_interactor.rb"
    end

    test "generates application representer" do
      run_generator
      assert_file "app/representers/application_representer.rb"
    end

    test "generates directory for facade concerns" do
      run_generator
      assert_directory "app/facades/concerns"
    end

    test "generates directory for interactor concerns" do
      run_generator
      assert_directory "app/interactors/concerns"
    end

    test "generates directory for representers concerns" do
      run_generator
      assert_directory "app/representers/concerns"
    end
  end
end
