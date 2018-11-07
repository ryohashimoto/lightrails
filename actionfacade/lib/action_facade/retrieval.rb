# frozen_string_literal: true

module ActionFacade
  module Retrieval
    def retrieve(facade, *variable_names)
      variable_names.each do |name|
        instance_variable_set("@#{name}", facade.send(name.to_sym))
      end
    end

    def retrieve_facade(*variable_names)
      facade = guessed_facade.new(params)
      retrieve facade, *variable_names
    end

    private

      def guessed_facade
        "#{self.class.name.gsub(/Controller$/, '').capitalize}::#{action_name.capitalize}Facade".constantize
      end
  end
end
