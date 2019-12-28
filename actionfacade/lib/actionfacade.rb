# frozen_string_literal: true

$:.unshift File.dirname(__FILE__)

module ActionFacade
  autoload :Base, "action_facade/base"
  autoload :Retrieval, "action_facade/retrieval"
end
