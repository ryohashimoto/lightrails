require "test/unit"
require_relative "../lib/actioninteractor"

class StatusTest < Test::Unit::TestCase
  test "initialized correctly" do
    assert_nothing_raised { ActionInteractor::State.new }
  end

  test "initial state is :initial" do
    state = ActionInteractor::State.new
    assert_equal(state.state, :initial)
  end

  test "default states are :initial, :processing, :successful and :failure" do
    state = ActionInteractor::State.new
    assert_equal(state.states, [:initial, :processing, :successful, :failure])
  end

  test "default transitions are defined correctly" do
    state = ActionInteractor::State.new
    assert_equal(
      state.transitions,
      {
        initial: [:processing],
        processing: [:initial],
        successful: [:processing],
        failure: [:processing],
      }
    )
  end

  test "able to change state from :initial to :processing" do
    state = ActionInteractor::State.new
    assert_equal(state.initial?, true)
    state.processing!
    assert_equal(state.processing?, true)
  end

  test "raise TransitionError when try to change state from :initial to :successful" do
    state = ActionInteractor::State.new
    assert_equal(state.valid_transition?(:successful), false)
    error = assert_raises ActionInteractor::State::TransitionError do
      state.successful!
    end
    assert_equal("Could not change state :successful from :initial", error.message)
  end

  test "able to change state from :processing to :failure" do
    state = ActionInteractor::State.new(:processing)
    state.failure!
    assert_equal(state.failure?, true)
  end
end
