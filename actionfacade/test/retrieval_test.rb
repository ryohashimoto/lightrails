require "test/unit"
require_relative "../lib/action_facade/base.rb"
require_relative "../lib/action_facade/retrieval.rb"

class UserFacade < ActionFacade::Base
  USER_DATA = [{ id: 1, name: "john" }]

  def john
    USER_DATA.find { |user| user[:name] == "john" }
  end
end

class UsersController
  include ActionFacade::Retrieval

  attr_reader :john

  def show
    params = {}
    facade = UserFacade.new(params)
    retrieve(facade, :john)
  end

  def edit
    params = {}
    retrieve_facade :john
  end
end

class RetrievalTest < Test::Unit::TestCase
  test ".show does not raise error" do
    assert_nothing_raised { UsersController.new.show }
  end

  test "@john is set after retrieve(facade, :john)" do
    controller = UsersController.new
    assert_nil(controller.john)
    controller.show
    assert_equal(controller.john, { id: 1, name: "john" })
  end

  test "@john is set after retrieve_facade(:john)" do
    controller = UsersController.new
    assert_nil(controller.john)
    controller.edit
    assert_equal(controller.john, { id: 1, name: "john" })
  end
end
