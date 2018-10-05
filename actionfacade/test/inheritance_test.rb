require "test/unit"
require "actionfacade"

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
    params = {}
    assert_nothing_raised { UserFacade.new(params) }
  end

  test "#params returns user object" do
    params = {}
    facade = UserFacade.new(params)
    assert_equal(facade.params, params)
  end

  test "#all returns all data" do
    params = {}
    facade = UserFacade.new(params)
    assert_equal(facade.all, [{ id: 1, name: "john" }, { id: 2, name: "taro" }])
  end

  test "#taro returns taro's data" do
    params = {}
    facade = UserFacade.new(params)
    assert_equal(facade.taro, { id: 2, name: "taro" })
  end
end
