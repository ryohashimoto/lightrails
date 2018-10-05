require 'active_support/core_ext/module/delegation'

module ActiveRepresenter
  class Base
    attr_reader :wrapped

    delegate_missing_to :wrapped

    def initialize(wrapped)
      @wrapped = wrapped
    end
  end
end
