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
  end
end
