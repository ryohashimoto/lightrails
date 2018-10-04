require "test/unit"
require "activerepresenter"
require "ostruct"

class UserRepresenter < ActiveRepresenter::Base
  def full_name
    "#{first_name} #{last_name}"
  end
end

class InheritanceTest < Test::Unit::TestCase
  test ".new does not raise error" do
    user = OpenStruct.new(first_name: 'John', last_name: 'Appleseed')
    assert_nothing_raised { UserRepresenter.new(user) }
  end

  test "#wrapped returns user object" do
    user = OpenStruct.new(first_name: 'John', last_name: 'Appleseed')
    representer = UserRepresenter.new(user)
    assert_equal(representer.wrapped, user)
  end

  test "#first_name returns John" do
    user = OpenStruct.new(first_name: 'John', last_name: 'Appleseed')
    representer = UserRepresenter.new(user)
    assert_equal(representer.first_name, 'John')
  end

  test "#last_name returns Appleseed" do
    user = OpenStruct.new(first_name: 'John', last_name: 'Appleseed')
    representer = UserRepresenter.new(user)
    assert_equal(representer.last_name, 'Appleseed')
  end

  test "#full_name returns John Appleseed" do
    user = OpenStruct.new(first_name: 'John', last_name: 'Appleseed')
    representer = UserRepresenter.new(user)
    assert_equal(representer.full_name, 'John Appleseed')
  end
end
