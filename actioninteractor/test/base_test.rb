require "test/unit"
require_relative "../lib/base.rb"

class BaseTest < Test::Unit::TestCase
  test ".execute does not raise error" do
    params = {}
    assert_nothing_raised { ActionInteractor::Base.execute(params) }
  end

  test ".execute returns an ActionInteractor::Base instance" do
    params = {}
    interactor = ActionInteractor::Base.execute(params)
    assert_instance_of(ActionInteractor::Base, interactor)
  end

  test "the result is an empty hash" do
    params = {}
    interactor = ActionInteractor::Base.execute(params)
    assert_equal({}, interactor.result)
  end

  test "#success? is true" do
    params = {}
    interactor = ActionInteractor::Base.execute(params)
    assert interactor.success?
  end

  test "#completed? is true" do
    params = {}
    interactor = ActionInteractor::Base.execute(params)
    assert interactor.completed?
  end
end
