require "test_helper"
require "generators/action_interactor/install_generator"

module ActionInteractor
  class InstallGeneratorTest < ::Rails::Generators::TestCase
    tests ActionInteractor::Generators::InstallGenerator
    destination File.expand_path('../../tmp', __FILE__)
    setup :prepare_destination
    teardown { rm_rf(destination_root) }

    test "generates application interactor" do
      run_generator
      assert_file "app/interactors/application_interactor.rb"
    end

    test "generates directory for interactor concerns" do
      run_generator
      assert_directory "app/interactors/concerns"
    end
  end
end
