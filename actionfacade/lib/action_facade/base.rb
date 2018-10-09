# frozen_string_literal: true

module ActionFacade
  class Base
    attr_reader :params

    # pass controller's params by default
    def initialize(params)
      @params = params
    end
  end
end
