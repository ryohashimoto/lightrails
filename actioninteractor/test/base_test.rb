require "test/unit"
require_relative "../lib/actioninteractor"
require "pry"

class BaseTest < Test::Unit::TestCase
  test "initialized successfully" do
    payload = {}
    interactor = ActionInteractor::Base.new(payload)
    assert_equal(interactor.success?, false)
    assert_equal(interactor.finished?, false)
    assert_equal(interactor.errors.empty?, true)
  end

  test ".execute does not raise error" do
    payload = {}
    assert_nothing_raised { ActionInteractor::Base.execute(payload) }
  end

  test ".execute returns an ActionInteractor::Base instance" do
    payload = {}
    interactor = ActionInteractor::Base.execute(payload)
    assert_instance_of(ActionInteractor::Base, interactor)
  end

  test ".execute! also returns an ActionInteractor::Base instance" do
    payload = {}
    interactor = ActionInteractor::Base.execute!(payload)
    assert_instance_of(ActionInteractor::Base, interactor)
  end

  test "the result is an instance of ActionInteractor::Results" do
    payload = {}
    interactor = ActionInteractor::Base.execute(payload)
    assert_instance_of(ActionInteractor::Results, interactor.results)
  end

  test "#successful? is true" do
    payload = {}
    interactor = ActionInteractor::Base.execute(payload)
    assert interactor.successful?
  end

  test "#success? (alias) is true" do
    payload = {}
    interactor = ActionInteractor::Base.execute(payload)
    assert interactor.success?
  end

  test "#finished? is true" do
    payload = {}
    interactor = ActionInteractor::Base.execute(payload)
    assert interactor.finished?
  end

  test "#aborted? is true after #abort!" do
    payload = {}
    interactor = ActionInteractor::Base.new(payload)
    interactor.abort!
    assert interactor.aborted?
  end
end
