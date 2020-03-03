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
    unless payload[:name]
      errors.add(:name, "can't be blank.")
      return failure!
    end
    results.add(:user, User.new(name: payload[:name]))
    successful!
  end
end

class NotificationInteractor < ActionInteractor::Base
  def execute
    errors.add(:name, "can't be blank.") unless payload[:name]
    errors.add(:email, "can't be blank.") unless payload[:email]
    return failure! if errors.any?
    results.add(:name, payload[:name])
    results.add(:email, payload[:email])
    successful!
  end
end


class InheritanceTest < Test::Unit::TestCase
  test ".execute does not raise error" do
    payload = { name: 'John'}
    assert_nothing_raised { RegistrationInteractor.execute(payload) }
  end

  test "returns 'registration_interactor' as default interactor name" do
    payload = { name: 'John'}
    interactor = RegistrationInteractor.new(payload)
    assert_equal('registration_interactor', interactor.interactor_name)
  end

  test "returns 'registration' as specified interactor name" do
    payload = { name: 'John', interactor_name: 'registration' }
    interactor = RegistrationInteractor.new(payload)
    assert_equal('registration', interactor.interactor_name)
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

  test "#successful? is true" do
    payload = { name: 'John'}
    interactor = RegistrationInteractor.execute(payload)
    assert interactor.successful?
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

  test "if none is given, the registration and notification will fail." do
    payload = {}
    registration = RegistrationInteractor.execute(payload)
    assert registration.failure?
    assert registration.errors.any?
    assert_equal(registration.errors.to_hash, { name: "can't be blank." })
    assert_equal(registration.errors.messages, ["name can't be blank."])
    notification = NotificationInteractor.execute(payload)
    assert notification.failure?
    assert notification.errors.any?
    assert_equal(notification.errors.to_hash, { name: "can't be blank.", email: "can't be blank." })
    assert_equal(notification.errors.messages, ["name can't be blank.", "email can't be blank."])
  end

  test "if only the name is given, the registration is successful but the notification is not." do
    payload = { name: 'Taro' }
    registration = RegistrationInteractor.execute(payload)
    assert registration.successful?
    assert registration.errors.empty?
    notification = NotificationInteractor.execute(payload)
    assert notification.failure?
    assert notification.errors.any?
    assert_equal(notification.errors.to_hash, { email: "can't be blank." })
    assert_equal(notification.errors.messages, ["email can't be blank."])
  end
end
