module ActionInteractor
  class Base
    attr_reader :params, :result

    def initialize(params)
      @params = params
      @proceeded = false
      @success = false
      @result = {}
    end

    def execute
      return if @proceeded == true
      @proceeded = true
      @success = true
    end

    def proceeded?
      @proceeded
    end

    def success?
      @success
    end

    def failure?
      !success?
    end

    class << self
      def execute(params)
        new(params).tap(&:execute)
      end
    end
  end
end
