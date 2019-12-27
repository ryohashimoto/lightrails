require "test/unit"
require_relative "../lib/actioninteractor"

class ErrorsTest < Test::Unit::TestCase
  test "initialized correctly" do
    assert_nothing_raised { ActionInteractor::Errors.new }
  end

  test "add result for the key" do
    errors = ActionInteractor::Errors.new
    errors.add(:foo, "bar")
    assert_equal(errors[:foo], "bar")
  end

  test "delete the result for the key" do
    errors = ActionInteractor::Errors.new
    errors.add(:foo, "bar")
    errors.delete(:foo)
    assert_equal(errors[:foo], nil)
  end

  test "iterate through the errors" do
    errors = ActionInteractor::Errors.new
    errors.add(:foo, "foo")
    errors.add(:bar, "bar")
    errors.add(:baz, "baz")
    info = []
    errors.each do |attribute, result|
      info << [attribute, result]
    end
    assert_equal(info[0], [:foo, "foo"])
    assert_equal(info[1], [:bar, "bar"])
    assert_equal(info[2], [:baz, "baz"])
  end
end
