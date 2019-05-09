require "test/unit"
require_relative "../lib/actioninteractor"

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

  test "the result is an instance of ActionInteractor::Results" do
    params = {}
    interactor = ActionInteractor::Base.execute(params)
    assert_instance_of(ActionInteractor::Results, interactor.results)
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
