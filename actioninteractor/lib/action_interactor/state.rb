# frozen_string_literal: true

module ActionInteractor
  class State
    # Define default states
    STATES = [
      :initial,    # Initial state
      :processing, # The operation is processing
      :successful, # The operation is finished successfully
      :failure,    # The operation is failed
    ]

    # Define default transitions
    # key: target state, values: original state
    TRANSITIONS = {
      initial: [:processing],
      processing: [:initial],
      successful: [:processing],
      failure: [:processing],
    }

    attr_reader :state

    def initialize(initial_state=nil)
      @state = initial_state || default_state
    end

    def default_state
      :initial
    end

    # Returns true if transition to target_state from current state.
    def valid_transition?(target_state)
      transitions[target_state].include?(state)
    end

    def states
      self.class.states
    end

    def transitions
      self.class.transitions
    end

    def self.states
      STATES
    end

    def self.transitions
      TRANSITIONS
    end

    self.states.each do |state_name|
      define_method("#{state_name}?") do
        state == state_name
      end

      define_method("#{state_name}!") do
        unless valid_transition?(state_name)
          raise TransitionError.new("Could not change state :#{state_name} from :#{state}")
        end
        @state = state_name
      end
    end

    class TransitionError < StandardError; end
  end
end
