require "test/unit"
require "ostruct"
require "active_support/time"
require_relative "../lib/active_representer/base.rb"

class ActivityRepresenter < ActiveRepresenter::Base
  def created_on
    created_at.to_date
  end
end

class UserRepresenter < ActiveRepresenter::Base
  attr_collection :activities
  attr_collection :notifications

  def full_name
    "#{first_name} #{last_name}"
  end
end

class AttrCollectionTest < Test::Unit::TestCase
  test ".wrap does not raise error" do
    user = OpenStruct.new(first_name: 'John', last_name: 'Appleseed')
    assert_nothing_raised { UserRepresenter.wrap(user) }
  end

  test "#full_name returns John Appleseed" do
    user = OpenStruct.new(first_name: 'John', last_name: 'Appleseed')
    representer = UserRepresenter.wrap(user)
    assert_equal(representer.full_name, 'John Appleseed')
  end

  test ".wrap does not raise error when activities are specified" do
    user = OpenStruct.new(
      first_name: 'John',
      last_name: 'Appleseed',
      activities: [OpenStruct.new(created_at: Time.now)]
    )
    assert_nothing_raised { UserRepresenter.wrap(user) }
  end

  test "activity is represented" do
    user = OpenStruct.new(
      first_name: 'John',
      last_name: 'Appleseed',
      activities: [OpenStruct.new(created_at: Time.now)]
    )
    representer = UserRepresenter.wrap(user)
    activity = representer.activities.first
    assert_instance_of(ActivityRepresenter, activity)
  end

  test "activity.created_on is Date.today" do
    user = OpenStruct.new(
      first_name: 'John',
      last_name: 'Appleseed',
      activities: [OpenStruct.new(created_at: Time.now)]
    )
    representer = UserRepresenter.wrap(user)
    activity = representer.activities.first
    assert_equal(activity.created_on, Date.today)
  end

  test "notification is not represented" do
    user = OpenStruct.new(
      first_name: 'John',
      last_name: 'Appleseed',
      notifications: [OpenStruct.new(created_at: Time.now)]
    )
    representer = UserRepresenter.wrap(user)
    notification = representer.notifications.first
    assert_instance_of(OpenStruct, notification)
  end
end
