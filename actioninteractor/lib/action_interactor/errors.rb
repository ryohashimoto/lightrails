# frozen_string_literal: true

require "forwardable"

module ActionInteractor
  # == Action \Interactor \Errors
  # Provides a +Hash+ like object to Action Interactors execution errors.
  class Errors
    include Enumerable
    extend Forwardable

    attr_reader :errors

    def_delegators :@errors, :clear, :keys, :values, :[], :empty?, :any?, :each, :each_pair

    def initialize(*)
      @errors = {}
    end

    # Add +error+ to the errors hash.
    def add(attribute, error)
      errors[attribute.to_sym] = error
    end

    # Delete a error for +key+.
    def delete(key)
      attribute = key.to_sym
      errors.delete(attribute)
    end

    # Iterates through each error key, value pair in the errors hash.
    def each
      errors.each_key do |attribute|
        yield attribute, errors[attribute]
      end
    end

    # Convert errors to hash.
    def to_hash
      errors
    end

    # Returns array containing error messages.
    def messages
      errors.map do |attribute, error|
        "#{attribute} #{error}"
      end
    end
  end
end
