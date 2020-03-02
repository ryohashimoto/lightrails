# frozen_string_literal: true

module ActionInteractor
  class State
    # Define default states
    STATES = [:initial, :finished]

    # Define default transitions
    # key: target state, value: original states
    TRANSITIONS = {
      finished: [:initial]
    }

    attr_reader :state

    def initialize(initial_state=nil)
      @state = initial_state || default_state
    end

    def default_state
      :initial
    end

    # Returns true if transition to target_state from current state
    def valid_transition?(target_state)
      transitions[target_state].include?(state)
    end

    # Available states for the instance
    def states
      self.class.states
    end

    # Avaiolable transitions for the instance's states
    def transitions
      self.class.transitions
    end

    # Available states for the class
    def self.states
      self::STATES
    end

    # Available transitions for the class
    def self.transitions
      self::TRANSITIONS
    end

    def method_missing(method_name, *args)
      name = method_name.to_s
      # Returns true if state_name is the same as current state
      if status_method_with_suffix?(name, "?")
        return state == name.chop.to_sym
      end

      # Set current state to the state_name, otherwise raises error
      if status_method_with_suffix?(name, "!")
        state_name = name.chop.to_sym
        unless valid_transition?(state_name)
          raise TransitionError.new("Could not change state :#{state_name} from :#{state}")
        end
        @state = state_name
        return
      end

      super
    end

    private

    def status_method_with_suffix?(method_name, suffix)
      return false unless method_name.end_with?(suffix)
      states.include?(method_name.chop.to_sym)
    end

    # Error for invalid transitions
    class TransitionError < StandardError; end
  end
end
