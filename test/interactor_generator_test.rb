require "test_helper"
require "generators/interactor_generator"

class Rails::Generators::InteractorGeneratorTest < ::Rails::Generators::TestCase
  tests Rails::Generators::InteractorGenerator
  destination File.expand_path('../../tmp', __FILE__)
  setup :prepare_destination
  teardown { rm_rf(destination_root) }

  test "generates registration interactor" do
    run_generator ["registration"]
    assert_file "app/interactors/registration_interactor.rb"
  end
end
