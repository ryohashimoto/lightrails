require "test/unit"
require "actioninteractor"

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

  test "#finished? is true" do
    params = {}
    interactor = ActionInteractor::Base.execute(params)
    assert interactor.finished?
  end

  test "#aborted? is true after #abort!" do
    params = {}
    interactor = ActionInteractor::Base.execute(params)
    interactor.abort!
    assert interactor.aborted?
  end
end
