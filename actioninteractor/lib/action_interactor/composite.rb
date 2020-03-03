# frozen_string_literal: true

module ActionInteractor
  class Composite < Base
    attr_reader :interactors

    def initialize(payload)
      super
      @interactors = []
    end

    def execute
      return if finished?
      return failure! if payload.nil?

      interactors.each_with_index do |interactor, index|
        execute_sub_interactor(interactor, index)
        return failure! if interactor.failure?
      end

      successful!
    end

    def add(interactor)
      interactors << interactor
    end

    def delete(interactor)
      interactors.delete(interactor)
    end

    private

    def execute_sub_interactor(interactor, index)
      interactor.execute
      if interactor.successful?
        interactor.results.each_pair do |attr_name, value|
          results.add(sub_attr_key(interactor, index, attr_name), value)
        end
      else interactor.failure?
        interactor.errors.each_pair do |attr_name, value|
          errors.add(sub_attr_key(interactor, index, attr_name), value)
        end
      end
    end

    def sub_attr_key(interactor, index, attr_name)
      "#{interactor.interactor_name}_#{index}__#{attr_name}".to_sym
    end
  end
end
