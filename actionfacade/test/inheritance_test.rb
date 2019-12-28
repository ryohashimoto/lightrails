require "test/unit"
require_relative "../lib/actionfacade"

class UserFacade < ActionFacade::Base
  USER_DATA = [{ id: 1, name: "john" }, { id: 2, name: "taro" }]

  def all
    USER_DATA
  end

  def taro
    all.find { |user| user[:name] == "taro" }
  end
end

class InheritanceTest < Test::Unit::TestCase
  test ".new does not raise error" do
    payload = {}
    assert_nothing_raised { UserFacade.new(payload) }
  end

  test "#payload returns user object" do
    payload = {}
    facade = UserFacade.new(payload)
    assert_equal(facade.payload, payload)
  end

  test "#all returns all data" do
    payload = {}
    facade = UserFacade.new(payload)
    assert_equal(facade.all, [{ id: 1, name: "john" }, { id: 2, name: "taro" }])
  end

  test "#taro returns taro's data" do
    payload = {}
    facade = UserFacade.new(payload)
    assert_equal(facade.taro, { id: 2, name: "taro" })
  end
end
