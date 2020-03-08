require_relative "./test_helper"

class BaseTest < Test::Unit::TestCase
  test ".new does not raise error" do
    payload = {}
    assert_nothing_raised { ActionFacade::Base.new(payload) }
  end

  test "#payload returns original payload object" do
    payload = {}
    facade = ActionFacade::Base.new(payload)
    assert_equal(facade.payload, payload)
  end
end
