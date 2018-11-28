require "test/unit"
require "ostruct"
require_relative "../lib/active_representer/base.rb"

class UserRepresenter < ActiveRepresenter::Base
  attr_field :first_name, :string
  attr_field :last_name, :string
  attr_field :age, :integer

  def full_name
    "#{first_name} #{last_name}"
  end
end

class AttrFieldTest < Test::Unit::TestCase
  test ".wrap does not raise error" do
    user = OpenStruct.new(first_name: 'John', last_name: 'Appleseed')
    assert_nothing_raised { UserRepresenter.wrap(user) }
  end

  test "#wrapped returns user object" do
    user = OpenStruct.new(first_name: 'John', last_name: 'Appleseed')
    representer = UserRepresenter.wrap(user)
    assert_equal(representer.wrapped, user)
  end

  test "#first_name returns John" do
    user = OpenStruct.new(first_name: 'John', last_name: 'Appleseed')
    representer = UserRepresenter.wrap(user)
    assert_equal(representer.first_name, 'John')
  end

  test "#last_name returns Appleseed" do
    user = OpenStruct.new(first_name: 'John', last_name: 'Appleseed')
    representer = UserRepresenter.wrap(user)
    assert_equal(representer.last_name, 'Appleseed')
  end

  test "#full_name returns John Appleseed" do
    user = OpenStruct.new(first_name: 'John', last_name: 'Appleseed')
    representer = UserRepresenter.wrap(user)
    assert_equal(representer.full_name, 'John Appleseed')
  end

  test "#age returns 30" do
    user = OpenStruct.new(first_name: 'John', last_name: 'Appleseed', age: 30)
    representer = UserRepresenter.wrap(user)
    assert_equal(representer.age, 30)
  end
end
