# frozen_string_literal: true

module ActionInteractor
  # == Action \Interactor \Base
  #
  # This is a base class for an interactor (data processing unit).
  # It gets a payload (input) as an initialization parameter and
  # execute some methods which is described in `execute` method.
  # After that, the results can be obtained by `results` method.
  # In Ruby on Rails, it can be used for doing some business logic
  # like new user registration process. For example inserting user data
  # in the database and creating a notification message, registering a
  # job for sending the message.
  #
  # class RegistrationInteractor < ActionInteractor::Base
  #   def execute
  #     return failure! unless payload[:name]
  #     user = User.create!(name: payload[:name])
  #     notiticaion = user.notifications.create!(name: 'Welcome')
  #     RegistrationNotificationJob.perform_later!
  #     results.add(:user, user)
  #     successful!
  #   end
  # end
  class Base
    attr_reader :payload, :errors, :results, :state, :interactor_name

    # Initialize with payload
    # Errors and Results data and initial state will be set.
    def initialize(payload = {})
      @payload = payload
      @errors = payload[:errors] || Errors.new
      @results = payload[:results] || Results.new
      @state = payload[:state] || ExecutionState.new
      @interactor_name = payload[:interactor_name] || underscore(self.class.name)
    end

    # Execute the operation with given payload.
    # (Should be overridden.)
    def execute
      # if the interactor already finished execution, do nothing.
      return if finished?
      # if contract is not satisfied= (ex: payload is nil), mark as failure.
      return failure! if payload.nil?
      # (Implement some codes for the operation.)

      # if finished execution, mark as successful.
      successful!
    end

    # Execute the operation with given payload.
    # If there are some errors, ActionInteractor::ExeuctionError will be raised.
    def execute!
      execute
      successful? || raise(ExecutionError.new("Failed to execute the interactor"))
    end

    # Returns `true` if marked as finished otherwise `false`.
    def finished?
      state.successful? || state.failure?
    end

    # Returns `true` if not marked as finished otherwise `false`.
    def unfinished?
      !finished?
    end

    # Returns `true` if marked as success and there are no errors otherwise `false`.
    def successful?
      state.successful? && @errors.empty?
    end

    alias_method :success?, :successful?

    # Returns `true` if not marked as success or there are some errors otherwise `false`.
    def failure?
      !successful?
    end

    # Returns `true` if the operation was not successful and not finished otherwise `false`.
    def aborted?
      state.aborted?
    end

    # Reset statuses.
    def reset!
      @state = State.new
    end

    # Mark the operation as aborted.
    def abort!
      state.aborted!
    end

    # Mark the operation as successful.
    def successful!
      state.successful!
    end

    alias_method :success!, :successful!

    # Mask the operation as failure.
    def failure!
      state.failure!
    end

    alias_method :fail!, :failure!

    class << self
      # Execute the operation with given payload.
      def execute(payload = {})
        new(payload).tap(&:execute)
      end

      # Execute the operation with given payload.
      # If there are some errors, ActionInteractor::ExeuctionError will be raised.
      def execute!(payload = {})
        new(payload).tap(&:execute!)
      end
    end

    private

    def underscore(name)
      name.gsub(/::/, "__")
          .gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
          .gsub(/([a-z\d])([A-Z])/,'\1_\2')
          .tr("-", "_")
          .downcase
    end
  end

  class ExecutionError < StandardError; end
end
