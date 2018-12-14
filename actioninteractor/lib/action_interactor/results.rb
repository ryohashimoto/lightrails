# frozen_string_literal: true

require "forwardable"

module ActionInteractor
  class Results
    include Enumerable
    extend Forwardable

    attr_reader :_results

    def_delegators :@_results, :clear, :keys, :values, :[], :delete

    def initialize(*)
      @_results = {}
    end

    def add(attribute, detail)
      _results[attribute.to_sym] = detail
    end
  end
end
