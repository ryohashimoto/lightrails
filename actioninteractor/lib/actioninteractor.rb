# frozen_string_literal: true

$:.unshift File.dirname(__FILE__)

module ActionInteractor
  autoload :Base, "action_interactor/base"
  autoload :Results, "action_interactor/results"
end
