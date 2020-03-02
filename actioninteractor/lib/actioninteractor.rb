# frozen_string_literal: true

$:.unshift File.dirname(__FILE__)

module ActionInteractor
  autoload :Base, "action_interactor/base"
  autoload :Errors, "action_interactor/errors"
  autoload :Results, "action_interactor/results"
  autoload :State, "action_interactor/state"
end
