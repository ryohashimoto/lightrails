# frozen_string_literal: true

require "active_support/core_ext/string/inflections"

module ActionFacade
  # == Action \Facade \Retrieval
  #
  # This module provides `retrieve` method to the class which includes the module.
  # The `retrieve` method can be used for obtaining data from the external facade.
  # In Ruby on Rails controllers, this module can be used for assing many instance
  # variables by extracting Active Record queries to the class that is inherited
  # from ActionFacade::Base.
  module Retrieval
    # Retrieve data from `facade`
    #
    # `variable_names` are symbols for the method names in the facade and
    # they will be set as instance variables in the class that
    # includes the module.
    def retrieve(facade, *variable_names)
      variable_names.each do |name|
        instance_variable_set("@#{name}", facade.send(name.to_sym))
      end
    end

    # Retrieve data from given payload
    #
    # If the class which includes the module is Rails controller,
    # guessed facade name will be "Controller" is replaced by the action name + "Facade".
    # If the class is not Rails controller, the name will be suffixed by "Facade".
    #
    # `payload` is the initialization parameter for the facade.
    #
    # `variable_names` are symbols for the method names in the facade and
    # they will be set as instance variables in the class that
    # includes the module.
    def retrieve_from(payload, *variable_names)
      facade = guess_facade
      if facade.nil?
        raise FacadeNotFoundError.new("Could not find Facade class #{guess_facade_name}.")
      end
      retrieve(facade.new(payload), *variable_names)
    end

    class FacadeNotFoundError < StandardError; end

    private

    def guess_facade
      facade_name = guess_facade_name
      begin
        facade_name.constantize
      rescue NameError
        nil
      end
    end

    def guess_facade_name
      klass_name = self.class.name
      if klass_name.end_with?("Controller")
        if defined?(params) && params[:action]
          klass_name.delete_suffix("Controller") + "::#{params[:action].camelize}Facade"
        else
          klass_name.delete_suffix("Controller") + "Facade"
        end
      else
        klass_name + "Facade"
      end
    end
  end
end
