require "test/unit"
require "actionfacade"

class BaseTest < Test::Unit::TestCase
  test ".new does not raise error" do
    params = {}
    assert_nothing_raised { ActionFacade::Base.new(params) }
  end

  test "#params returns original params object" do
    params = {}
    facade = ActionFacade::Base.new(params)
    assert_equal(facade.params, params)
  end
end
