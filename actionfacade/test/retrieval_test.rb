require "test/unit"
require_relative "../lib/action_facade/base.rb"
require_relative "../lib/action_facade/retrieval.rb"

USER_DATA = [{ id: 1, name: "john" }, { id: 2, name: "bob" }]

class UsersFacade < ActionFacade::Base
  def john
    USER_DATA.find { |user| user[:name] == "john" }
  end
end

module Admin
  class ShowFacade < ActionFacade::Base
    def bob
      USER_DATA.find { |user| user[:name] == "bob" }
    end
  end
end

class UsersController
  include ActionFacade::Retrieval

  attr_reader :john

  def show
    payload = {}
    facade = UsersFacade.new(payload)
    retrieve(facade, :john)
  end

  def show_from
    payload = {}
    retrieve_from(payload, :john)
  end
end

class AdminController
  include ActionFacade::Retrieval

  attr_reader :bob

  def show
    payload = {}
    retrieve_from(payload, :bob)
  end

  private

  def params
    { action: 'show' }
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

  test "@john is set after retrieve_from(payload, :john)" do
    controller = UsersController.new
    assert_nil(controller.john)
    controller.show_from
    assert_equal(controller.john, { id: 1, name: "john" })
  end

  test "@bob is set after retrieve_from(payload, :bob)" do
    controller = AdminController.new
    assert_nil(controller.bob)
    controller.show
    assert_equal(controller.bob, { id: 2, name: "bob" })
  end
end
