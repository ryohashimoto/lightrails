require "test_helper"
require "generators/facade_generator"

class Rails::Generators::FacadeGeneratorTest < ::Rails::Generators::TestCase
  tests Rails::Generators::FacadeGenerator
  destination File.expand_path('../../tmp', __FILE__)
  setup :prepare_destination
  teardown { rm_rf(destination_root) }

  test "generates mypage/index_facade" do
    run_generator ["mypage/index"]
    assert_file "app/facades/mypage/index_facade.rb"
  end
end
