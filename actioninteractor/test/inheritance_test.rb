require "test/unit"
require_relative "../lib/action_interactor/base.rb"

class User
  attr_accessor :name

  def initialize(params)
    @name = params[:name]
  end
end

class RegistrationInteractor < ActionInteractor::Base
  def execute
    return fail! unless params[:name]
    add_result(:user, User.new(name: params[:name]))
    finish!
  end
end

class NotificationInteractor < ActionInteractor::Base
  def execute
    return fail! unless params[:name] || params[:email]
    results(name: params[:name], email: params[:email])
    finish!
  end
end


class InheritanceTest < Test::Unit::TestCase
  test ".execute does not raise error" do
    params = { name: 'John'}
    assert_nothing_raised { RegistrationInteractor.execute(params) }
  end

  test ".execute returns an RegistrationInteractor instance" do
    params = { name: 'John'}
    interactor = RegistrationInteractor.execute(params)
    assert_instance_of(RegistrationInteractor, interactor)
  end

  test "the result contains a user" do
    params = { name: 'John'}
    interactor = RegistrationInteractor.execute(params)
    assert_instance_of(User, interactor.result[:user])
  end

  test "the result user name is John" do
    params = { name: 'John'}
    interactor = RegistrationInteractor.execute(params)
    user = interactor.result[:user]
    assert_equal(user.name, 'John')
  end

  test "#success? is true" do
    params = { name: 'John'}
    interactor = RegistrationInteractor.execute(params)
    assert interactor.success?
  end

  test "#finished? is true" do
    params = { name: 'John'}
    interactor = RegistrationInteractor.execute(params)
    assert interactor.finished?
  end

  test "if params is empty, #failure? is true" do
    params = {}
    interactor = RegistrationInteractor.execute(params)
    assert interactor.failure?
  end

  test "if params is empty, #finished? is true" do
    params = {}
    interactor = RegistrationInteractor.execute(params)
    assert interactor.finished?
  end

  test "the result user name is Taro and email is taro@example.com" do
    params = { name: 'Taro', email: 'taro@example.com'}
    interactor = NotificationInteractor.execute(params)
    name = interactor.result[:name]
    assert_equal(name, 'Taro')
    email = interactor.result[:email]
    assert_equal(email, 'taro@example.com')
  end
end
