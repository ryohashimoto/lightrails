require "test/unit"
require_relative "../lib/actioninteractor"

class ExecutionStateTest < Test::Unit::TestCase
  test "initialized correctly" do
    assert_nothing_raised { ActionInteractor::ExecutionState.new }
  end

  test "initial state is :initial" do
    state = ActionInteractor::ExecutionState.new
    assert_equal(state.state, :initial)
  end

  test "default states are :initial, :processing, :successful and :failure" do
    state = ActionInteractor::ExecutionState.new
    assert_equal(state.states, [:initial, :processing, :successful, :failure])
  end

  test "default transitions are defined correctly" do
    state = ActionInteractor::ExecutionState.new
    assert_equal(
      state.transitions,
      {
        initial: [:processing],
        processing: [:initial],
        successful: [:initial, :processing],
        failure: [:initial, :processing],
      }
    )
  end

  test "able to change state from :initial to :processing" do
    state = ActionInteractor::ExecutionState.new
    assert_equal(state.initial?, true)
    state.processing!
    assert_equal(state.processing?, true)
  end

  test "able to change state from :processing to :successful" do
    state = ActionInteractor::ExecutionState.new(:processing)
    state.successful!
    assert_equal(state.successful?, true)
  end

  test "able to change state from :initial to :failure" do
    state = ActionInteractor::ExecutionState.new(:initial)
    state.failure!
    assert_equal(state.failure?, true)
  end

  test "raise TransitionError when try to change state from :successful to :failure" do
    state = ActionInteractor::ExecutionState.new(:successful)
    assert_equal(state.valid_transition?(:failure), false)
    error = assert_raises ActionInteractor::ExecutionState::TransitionError do
      state.failure!
    end
    assert_equal("Could not change state :failure from :successful", error.message)
  end
end
