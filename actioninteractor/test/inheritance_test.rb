require "test/unit"
require_relative "../lib/actioninteractor"

class User
  attr_accessor :name

  def initialize(params)
    @name = params[:name]
  end
end

class RegistrationInteractor < ActionInteractor::Base
  def execute
    return fail! unless params[:name]
    results.add(:user, User.new(name: params[:name]))
    success!
  end
end

class NotificationInteractor < ActionInteractor::Base
  def execute
    return fail! unless params[:name] || params[:email]
    results.add(:name, params[:name])
    results.add(:email, params[:email])
    success!
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
    assert_instance_of(User, interactor.results[:user])
  end

  test "the result user name is John" do
    params = { name: 'John'}
    interactor = RegistrationInteractor.execute(params)
    user = interactor.results[:user]
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

  test "if params is empty, .execute returns instance of RegistrationInteractor" do
    params = {}
    interactor = RegistrationInteractor.execute(params)
    assert_instance_of(RegistrationInteractor, interactor)
  end

  test "if params is empty, #execute! raises a ExecutionError" do
    params = {}
    interactor = RegistrationInteractor.new(params)
    error = assert_raises ActionInteractor::ExecutionError do
      interactor.execute!
    end
    assert_equal "Failed to execute the interactor", error.message
  end

  test "if params is empty, #execute! raises a ExecutionError" do
    params = {}
    error = assert_raises ActionInteractor::ExecutionError do
      RegistrationInteractor.execute!(params)
    end
    assert_equal "Failed to execute the interactor", error.message
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
    name = interactor.results[:name]
    assert_equal(name, 'Taro')
    email = interactor.results[:email]
    assert_equal(email, 'taro@example.com')
  end
end
