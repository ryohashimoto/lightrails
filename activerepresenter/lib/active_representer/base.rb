# frozen_string_literal: true

require "active_support/core_ext/class/attribute"
require "active_support/core_ext/module/delegation"
require "active_support/inflector"
require "pry"

module ActiveRepresenter
  class Base
    attr_reader :wrapped
    class_attribute :collections, default: {}

    delegate_missing_to :wrapped

    def initialize(wrapped)
      @wrapped = wrapped
      # set instance method's value
    end

    def self.attr_collection(name, **options)
      unless name.is_a?(Symbol) || name.is_a?(String)
        raise ArgumentError.new("collection's name must be a Symbol or a String")
      end
      representer_name = \
        options[:representer_name] ? options[:representer_name] : guess_representrer_name(name.to_s)
      raise ArgumentError.new("representer_name must be a String") unless representer_name.is_a?(String)
      begin
        representer = representer_name.constantize
      rescue NameError => e
        raise ArgumentError.new("representer_name must be a valid name")
      end
      collections[name.to_sym] = representer
      # define instance method
    end

    def self.guess_representrer_name(name)
      "#{name.singularize.camelize}Representer"
    end
  end
end
