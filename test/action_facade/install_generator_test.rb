require "test_helper"
require "generators/action_facade/install_generator"

module ActionFacade
  class InstallGeneratorTest < ::Rails::Generators::TestCase
    tests ActionFacade::Generators::InstallGenerator
    destination File.expand_path('../../tmp', __FILE__)
    setup :prepare_destination
    teardown { rm_rf(destination_root) }

    test "generates application facade" do
      run_generator
      assert_file "app/facades/application_facade.rb"
    end

    test "generates directory for facade concerns" do
      run_generator
      assert_directory "app/facades/concerns"
    end
  end
end
