require "test/unit"
require "ostruct"
require "active_support/time"
require_relative "../lib/active_representer/base.rb"

class ProfileRepresenter < ActiveRepresenter::Base
  def email_sent_on
    email_sent_at.to_date
  end
end

class UserRepresenter < ActiveRepresenter::Base
  attr_one :profile
end

class AttrOneTest < Test::Unit::TestCase
  test "profile is represented" do
    user = OpenStruct.new(
      profile: OpenStruct.new(email_sent_at: Time.now)
    )
    representer = UserRepresenter.wrap(user)
    profile = representer.profile
    assert_instance_of(ProfileRepresenter, profile)
  end

  test "profile.email_sent_on is Date.today" do
    user = OpenStruct.new(
      profile: OpenStruct.new(email_sent_at: Time.now)
    )
    representer = UserRepresenter.wrap(user)
    profile = representer.profile
    assert_equal(profile.email_sent_on, Date.today)
  end
end
