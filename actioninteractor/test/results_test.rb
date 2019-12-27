require "test/unit"
require_relative "../lib/actioninteractor"

class ResultsTest < Test::Unit::TestCase
  test "initialized correctly" do
    assert_nothing_raised { ActionInteractor::Results.new }
  end

  test "add result for the key" do
    results = ActionInteractor::Results.new
    results.add(:foo, "bar")
    assert_equal(results[:foo], "bar")
  end

  test "delete the result for the key" do
    results = ActionInteractor::Results.new
    results.add(:foo, "bar")
    results.delete(:foo)
    assert_equal(results[:foo], nil)
  end

  test "iterate through the results" do
    results = ActionInteractor::Results.new
    results.add(:foo, "foo")
    results.add(:bar, "bar")
    results.add(:baz, "baz")
    info = []
    results.each do |attribute, result|
      info << [attribute, result]
    end
    assert_equal(info[0], [:foo, "foo"])
    assert_equal(info[1], [:bar, "bar"])
    assert_equal(info[2], [:baz, "baz"])
  end

  test "get result by the key name's method" do
    results = ActionInteractor::Results.new
    assert_raises ::NoMethodError do
      results.foo
    end
    results.add(:foo, "bar")
    assert_equal(results.foo, "bar")
  end
end
