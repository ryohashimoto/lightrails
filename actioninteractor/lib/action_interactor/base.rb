# frozen_string_literal: true

module ActionInteractor
  class Base
    attr_reader :params, :result

    def initialize(params)
      @params = params
      reset!
    end

    def execute
      return if completed?
      finish!
    end

    def completed?
      @completed
    end

    def incomplete?
      !completed?
    end

    def success?
      @success
    end

    def failure?
      !success?
    end

    def aborted?
      failure? && incomplete?
    end

    def reset!
      @result = {}
      fail!
      incomplete!
    end

    def finish!
      success!
      complete!
    end

    def failed!
      fail!
      complete!
    end

    def abort!
      fail!
      incomplete!
    end

    def success!
      @success = true
    end

    def fail!
      @success = false
    end

    def complete!
      @completed = true
    end

    def incomplete!
      @completed = false
    end

    def add_result(key, value)
      @result[key] = value
    end

    class << self
      def execute(params)
        new(params).tap(&:execute)
      end
    end
  end
end
