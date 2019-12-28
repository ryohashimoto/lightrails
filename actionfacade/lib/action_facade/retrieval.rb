# frozen_string_literal: true

module ActionFacade
  module Retrieval
    def retrieve(facade, *variable_names)
      variable_names.each do |name|
        instance_variable_set("@#{name}", facade.send(name.to_sym))
      end
    end

    def facade_klass_name
      params[:controller].gsub(/Controller$/, "::") + params[:action].classify
    end

    def facade_klass
      facade_klass_name.constantize
    end

    def facade_for(payload)
      facade_klass.new(payload)
    end
  end
end
