require "test/unit"
require_relative "../lib/actioninteractor"

class BaseTest < Test::Unit::TestCase
  test "initialized successfully" do
    interactor = ActionInteractor::Base.new
    assert_equal(interactor.success?, false)
    assert_equal(interactor.finished?, false)
    assert_equal(interactor.errors.empty?, true)
  end

  test ".execute does not raise error" do
    assert_nothing_raised { ActionInteractor::Base.execute }
  end

  test ".execute returns an ActionInteractor::Base instance" do
    interactor = ActionInteractor::Base.execute
    assert_instance_of(ActionInteractor::Base, interactor)
  end

  test ".execute! also returns an ActionInteractor::Base instance" do
    interactor = ActionInteractor::Base.execute!
    assert_instance_of(ActionInteractor::Base, interactor)
  end

  test "the result is an instance of ActionInteractor::Results" do
    interactor = ActionInteractor::Base.execute
    assert_instance_of(ActionInteractor::Results, interactor.results)
  end

  test "#successful? is true" do
    interactor = ActionInteractor::Base.execute
    assert interactor.successful?
  end

  test "#success? (alias) is true" do
    interactor = ActionInteractor::Base.execute
    assert interactor.success?
  end

  test "#finished? is true" do
    interactor = ActionInteractor::Base.execute
    assert interactor.finished?
  end

  test "#aborted? is true after #abort!" do
    interactor = ActionInteractor::Base.new
    interactor.abort!
    assert interactor.aborted?
  end
end
