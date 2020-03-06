# frozen_string_literal: true

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

    # Retrieve data from guessed facade
    #
    # If the class which includes the module is Rails controller,
    # guessed facade name will be "Controller" is replaced by "Facade".
    # If the class is not Rails controller, the name will be suffixed by "Facade".
    #
    # `variable_names` are symbols for the method names in the facade and
    # they will be set as instance variables in the class that
    # includes the module.
    #
    # if the facade need to be initialize with parameters, use optional `payload` parameter.
    def retrieve_facade(*variable_names, payload: {})
      facade = guess_facade.new(payload)
      if facade.nil?
        raise FacadeNotFoundError.new("Could not find Facade class #{guess_facade_name}.")
      end
      retrieve(facade, *variable_names)
    end

    class FacadeNotFoundError < StandardError; end

    private

    def guess_facade
      facade_name = guess_facade_name
      begin
        Module.const_get(facade_name)
      rescue NameError
        nil
      end
    end

    def guess_facade_name
      klass_name = self.class.name
      if klass_name.end_with?("Controller")
        klass_name.delete_suffix("Controller") + "Facade"
      else
        klass_name + "Facade"
      end
    end
  end
end
