# frozen_string_literal: true

module ActionInteractor
  class Base
    attr_reader :payload, :errors, :results

    def initialize(payload)
      @payload = payload
      @errors = Errors.new
      @results = Results.new
      reset!
    end

    def execute
      # if the interactor already finished execution, do nothing.
      return if finished?
      # if contract is not satisfied= (ex: payload is empty), mark as failed.
      return fail! if payload.nil?
      # implement some codes
      # if finished execution, mark as success.
      success!
    end

    def execute!
      execute
      success? || raise(ExecutionError.new("Failed to execute the interactor"))
    end

    def finished?
      @_finished
    end

    def unfinished?
      !finished?
    end

    def success?
      @_success && @errors.empty?
    end

    def failure?
      !success?
    end

    def aborted?
      failure? && unfinished?
    end

    def reset!
      @_success = false
      @_finished = false
    end

    def abort!
      @_success = false
      @_finished = false
    end

    def success!
      @_success = true
      @_finished = true
    end

    def fail!
      @_success = false
      @_finished = true
    end

    class << self
      def execute(payload)
        new(payload).tap(&:execute)
      end

      def execute!(payload)
        new(payload).tap(&:execute!)
      end
    end
  end

  class ExecutionError < StandardError; end
end
