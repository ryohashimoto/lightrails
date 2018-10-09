require "test_helper"
require "generators/active_representer/install_generator"

module ActiveRepresenter
  class InstallGeneratorTest < ::Rails::Generators::TestCase
    tests ActiveRepresenter::Generators::InstallGenerator
    destination File.expand_path('../../tmp', __FILE__)
    setup :prepare_destination
    teardown { rm_rf(destination_root) }

    test "generates application representer" do
      run_generator
      assert_file "app/representers/application_representer.rb"
    end

    test "generates directory for representers concerns" do
      run_generator
      assert_directory "app/representers/concerns"
    end
  end
end
