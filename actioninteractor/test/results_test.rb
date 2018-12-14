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
end
