# frozen_string_literal: true

module ActionInteractor
  class Base
    attr_reader :payload, :errors, :results

    # Initialize with payload
    # Errors and Results data and initial state will be set.
    def initialize(payload)
      @payload = payload
      @errors = Errors.new
      @results = Results.new
      reset!
    end

    # Execute the operation with given payload.
    # (Should be overridden.)
    def execute
      # if the interactor already finished execution, do nothing.
      return if finished?
      # if contract is not satisfied= (ex: payload is empty), mark as failed.
      return fail! if payload.nil?
      # (Implement some codes for the operation.)

      # if finished execution, mark as success.
      success!
    end

    # Execute the operation with given payload.
    # If there are some errors, ActionInteractor::ExeuctionError will be raised.
    def execute!
      execute
      success? || raise(ExecutionError.new("Failed to execute the interactor"))
    end

    # Returns `true` if marked as finished otherwise `false`.
    def finished?
      @_finished
    end

    # Returns `true` if not marked as finished otherwise `false`.
    def unfinished?
      !finished?
    end

    # Returns `true` if marked as success and there are no errors otherwise `false`.
    def success?
      @_success && @errors.empty?
    end

    # Returns `true` if not marked as success or there are some errors otherwise `false`.
    def failure?
      !success?
    end

    # Returns `true` if the operation was not successful and not finished otherwise `false`.
    def aborted?
      failure? && unfinished?
    end

    # Reset statuses.
    def reset!
      @_success = false
      @_finished = false
    end

    # Mark the operation as failed and unfinished.
    def abort!
      @_success = false
      @_finished = false
    end

    # Mark the operation as success and finished.
    def success!
      @_success = true
      @_finished = true
    end

    # Mask the operation as failed and finished.
    def fail!
      @_success = false
      @_finished = true
    end

    class << self
      # Execute the operation with given payload.
      def execute(payload)
        new(payload).tap(&:execute)
      end

      # Execute the operation with given payload.
      # If there are some errors, ActionInteractor::ExeuctionError will be raised.
      def execute!(payload)
        new(payload).tap(&:execute!)
      end
    end
  end

  class ExecutionError < StandardError; end
end
