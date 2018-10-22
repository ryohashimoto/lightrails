# frozen_string_literal: true

module ActionFacade
  module Retrieval
    def retrieve(facade, *variable_names)
      variable_names.each do |name|
        instance_variable_set("@#{name}", facade.send(name.to_sym))
      end
    end
  end
end
