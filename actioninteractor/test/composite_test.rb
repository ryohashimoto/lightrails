require "test/unit"
require_relative "../lib/actioninteractor"

class ChiefInteractor < ActionInteractor::Composite
end

class CookInteractor < ActionInteractor::Base
  def execute
    results.add(:steak, "Juicy beaf steak")
    successful!
  end
end

class ArrangeInteractor < ActionInteractor::Base
  attr_reader :broken_dish

  def initialize(payload)
    super
    @broken_dish = payload[:broken_dish].nil? ? false : payload[:broken_dish]
  end

  def execute
    if broken_dish
      errors.add(:dish, "Broken dish")
      failure!
    else
      successful!
    end
  end
end


class CompositeTest < Test::Unit::TestCase
  test "initialized successfully" do
    payload = {}
    interactor = ActionInteractor::Composite.new(payload)
    assert_equal(interactor.success?, false)
    assert_equal(interactor.finished?, false)
    assert_equal(interactor.errors.empty?, true)
  end

  test "add interactors" do
    payload = {}
    chief_interactor = ChiefInteractor.new(payload)
    cook_interactor = CookInteractor.new(interactor_name: "cook")
    arrange_interactor = ArrangeInteractor.new(interactor_name: "arrange")
    chief_interactor.add(cook_interactor)
    chief_interactor.add(arrange_interactor)
    interactor_names = chief_interactor.interactors.map(&:interactor_name)
    assert_equal(interactor_names, %w[cook arrange])
  end

  test "remove interactor" do
    payload = {}
    chief_interactor = ChiefInteractor.new(payload)
    cook_interactor = CookInteractor.new(interactor_name: "cook")
    arrange_interactor = ArrangeInteractor.new(interactor_name: "arrange")
    chief_interactor.add(cook_interactor)
    chief_interactor.add(arrange_interactor)
    chief_interactor.delete(cook_interactor)
    interactor_names = chief_interactor.interactors.map(&:interactor_name)
    assert_equal(interactor_names, %w[arrange])
  end

  test "successful in executing all interactors" do
    payload = {}
    chief_interactor = ChiefInteractor.new(payload)
    cook_interactor = CookInteractor.new(interactor_name: "cook")
    arrange_interactor = ArrangeInteractor.new(interactor_name: "arrange")
    chief_interactor.add(cook_interactor)
    chief_interactor.add(arrange_interactor)
    chief_interactor.execute
    assert_equal(chief_interactor.successful?, true)
    assert_equal(chief_interactor.results.keys, [:cook_0__steak])
    assert_equal(chief_interactor.results[:cook_0__steak], "Juicy beaf steak")
  end

  test "failure in executing the last interactor" do
    payload = {}
    chief_interactor = ChiefInteractor.new(payload)
    cook_interactor = CookInteractor.new(interactor_name: "cook")
    arrange_interactor = ArrangeInteractor.new(interactor_name: "arrange", broken_dish: true)
    chief_interactor.add(cook_interactor)
    chief_interactor.add(arrange_interactor)
    chief_interactor.execute
    assert_equal(chief_interactor.successful?, false)
    assert_equal(chief_interactor.results.keys, [:cook_0__steak])
    assert_equal(chief_interactor.results[:cook_0__steak], "Juicy beaf steak")
    assert_equal(chief_interactor.errors.keys, [:arrange_1__dish])
    assert_equal(chief_interactor.errors[:arrange_1__dish], "Broken dish")
  end
end
