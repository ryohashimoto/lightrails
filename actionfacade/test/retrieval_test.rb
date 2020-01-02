require "test/unit"
require_relative "../lib/action_facade/base.rb"
require_relative "../lib/action_facade/retrieval.rb"

USER_DATA = [{ id: 1, name: "john" }]

class UserFacade < ActionFacade::Base
  def john
    USER_DATA.find { |user| user[:name] == "john" }
  end
end

class UsersController
  include ActionFacade::Retrieval

  attr_reader :john

  def show
    payload = {}
    facade = UserFacade.new(payload)
    retrieve(facade, :john)
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
end
