require_relative "./test_helper"

class BaseTest < Test::Unit::TestCase
  test ".new does not raise error" do
    assert_nothing_raised { ActionFacade::Base.new }
  end

  test "#payload returns original payload object" do
    facade = ActionFacade::Base.new
    assert_equal(facade.payload, {})
  end
end
