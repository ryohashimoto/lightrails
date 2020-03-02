# frozen_string_literal: true

module ActionInteractor
  class ExecutionState < State
    # Define default states
    STATES = [
      :initial,    # Initial state
      :processing, # The operation is processing
      :successful, # The operation is finished successfully
      :failure,    # The operation is failed
    ]

    # Define default transitions
    # key: target state, value: original states
    TRANSITIONS = {
      initial: [:processing],
      processing: [:initial],
      successful: [:initial, :processing],
      failure: [:initial, :processing],
    }
  end
end
