require "test/unit"
require_relative "../lib/actioninteractor"

class User
  attr_accessor :name

  def initialize(payload)
    @name = payload[:name]
  end
end

class RegistrationInteractor < ActionInteractor::Base
  def execute
    return fail! unless payload[:name]
    results.add(:user, User.new(name: payload[:name]))
    success!
  end
end

class NotificationInteractor < ActionInteractor::Base
  def execute
    return fail! unless payload[:name] || payload[:email]
    results.add(:name, payload[:name])
    results.add(:email, payload[:email])
    success!
  end
end


class InheritanceTest < Test::Unit::TestCase
  test ".execute does not raise error" do
    payload = { name: 'John'}
    assert_nothing_raised { RegistrationInteractor.execute(payload) }
  end

  test ".execute returns an RegistrationInteractor instance" do
    payload = { name: 'John'}
    interactor = RegistrationInteractor.execute(payload)
    assert_instance_of(RegistrationInteractor, interactor)
  end

  test "the result contains a user" do
    payload = { name: 'John'}
    interactor = RegistrationInteractor.execute(payload)
    assert_instance_of(User, interactor.results[:user])
  end

  test "the result user name is John" do
    payload = { name: 'John'}
    interactor = RegistrationInteractor.execute(payload)
    user = interactor.results[:user]
    assert_equal(user.name, 'John')
  end

  test "#success? is true" do
    payload = { name: 'John'}
    interactor = RegistrationInteractor.execute(payload)
    assert interactor.success?
  end

  test "#finished? is true" do
    payload = { name: 'John'}
    interactor = RegistrationInteractor.execute(payload)
    assert interactor.finished?
  end

  test "if payload is empty, .execute returns instance of RegistrationInteractor" do
    payload = {}
    interactor = RegistrationInteractor.execute(payload)
    assert_instance_of(RegistrationInteractor, interactor)
  end

  test "if payload is empty, #execute! raises a ExecutionError" do
    payload = {}
    interactor = RegistrationInteractor.new(payload)
    error = assert_raises ActionInteractor::ExecutionError do
      interactor.execute!
    end
    assert_equal "Failed to execute the interactor", error.message
  end

  test "if payload is empty, #failure? is true" do
    payload = {}
    interactor = RegistrationInteractor.execute(payload)
    assert interactor.failure?
  end

  test "if payload is empty, #finished? is true" do
    payload = {}
    interactor = RegistrationInteractor.execute(payload)
    assert interactor.finished?
  end

  test "the result user name is Taro and email is taro@example.com" do
    payload = { name: 'Taro', email: 'taro@example.com'}
    interactor = NotificationInteractor.execute(payload)
    name = interactor.results[:name]
    assert_equal(name, 'Taro')
    email = interactor.results[:email]
    assert_equal(email, 'taro@example.com')
  end
end
