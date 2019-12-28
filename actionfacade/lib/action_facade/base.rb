# frozen_string_literal: true

module ActionFacade
  class Base
    attr_reader :payload

    # Initialize with payload
    def initialize(payload)
      @payload = payload
    end
  end
end
