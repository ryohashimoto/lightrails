require "test/unit"
require_relative "../lib/active_representer/base.rb"
require "ostruct"
require "active_support/time"

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

class CollectionTest < Test::Unit::TestCase
  test ".new does not raise error" do
    user = OpenStruct.new(first_name: 'John', last_name: 'Appleseed')
    assert_nothing_raised { UserRepresenter.new(user) }
  end

  test "#full_name returns John Appleseed" do
    user = OpenStruct.new(first_name: 'John', last_name: 'Appleseed')
    representer = UserRepresenter.new(user)
    assert_equal(representer.full_name, 'John Appleseed')
  end

  test ".new does not raise error when activities are specified" do
    user = OpenStruct.new(
      first_name: 'John',
      last_name: 'Appleseed',
      activities: [OpenStruct.new(created_at: Time.now)]
    )
    assert_nothing_raised { UserRepresenter.new(user) }
  end

  test "activity is represented" do
    user = OpenStruct.new(
      first_name: 'John',
      last_name: 'Appleseed',
      activities: [OpenStruct.new(created_at: Time.now)]
    )
    representer = UserRepresenter.new(user)
    activity = representer.activities.first
    assert_instance_of(ActivityRepresenter, activity)
  end

  test "activity.created_on is Date.today" do
    user = OpenStruct.new(
      first_name: 'John',
      last_name: 'Appleseed',
      activities: [OpenStruct.new(created_at: Time.now)]
    )
    representer = UserRepresenter.new(user)
    activity = representer.activities.first
    assert_equal(activity.created_on, Date.today)
  end

  test "notification is not represented" do
    user = OpenStruct.new(
      first_name: 'John',
      last_name: 'Appleseed',
      notifications: [OpenStruct.new(created_at: Time.now)]
    )
    representer = UserRepresenter.new(user)
    notification = representer.notifications.first
    assert_instance_of(OpenStruct, notification)
  end
end
