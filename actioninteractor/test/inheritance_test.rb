require "test/unit"
require "pry"
require_relative "../lib/base.rb"

class User
  attr_accessor :name

  def initialize(params)
    @name = params[:name]
  end
end

class RegistrationInteractor < ActionInteractor::Base
  def execute
    if params[:name]
      @result[:user] = User.new(name: params[:name])
      @success = true
    end
    @proceeded = true
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

  test "#proceeded? is true" do
    params = { name: 'John'}
    interactor = RegistrationInteractor.execute(params)
    assert interactor.proceeded?
  end
end