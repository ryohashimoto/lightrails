# frozen_string_literal: true

module ActionInteractor
  # == Action \Interactor \Execution \State
  #
  # State machine used in `ActionInteractor::Base`
  class ExecutionState < State
    # Define default states
    STATES = [
      :initial,    # Initial state
      :processing, # The operation is processing
      :successful, # The operation is finished successfully
      :failure,    # The operation is failed
      :aborted,    # The operation is aborted
    ]

    # Define default transitions
    # key: target state, value: original states
    TRANSITIONS = {
      initial: [:processing],
      processing: [:initial],
      successful: [:initial, :processing],
      failure: [:initial, :processing],
      aborted: [:initial, :processing],
    }
  end
end
