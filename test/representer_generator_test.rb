require "test_helper"
require "generators/representer_generator"

class Rails::Generators::RepresenterGeneratorTest < ::Rails::Generators::TestCase
  tests Rails::Generators::RepresenterGenerator
  destination File.expand_path('../../tmp', __FILE__)
  setup :prepare_destination
  teardown { rm_rf(destination_root) }

  test "generates user representer" do
    run_generator ["user"]
    assert_file "app/representers/user_representer.rb"
  end
end
