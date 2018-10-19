# frozen_string_literal: true

require "active_support/core_ext/class/attribute"
require "active_support/core_ext/module/delegation"
require "active_support/inflector"

module ActiveRepresenter
  class Base
    attr_reader :wrapped
    class_attribute :collections, default: {}

    delegate_missing_to :wrapped

    def initialize(wrapped)
      @wrapped = wrapped
      self.class.collection_names.each do |collection_name|
        next if wrapped[collection_name].nil?
        representer = self.class.collections[collection_name]
        collection_value = \
          if representer
            wrapped[collection_name].map { |item| representer.new(item) }
          else
            wrapped[collection_name]
          end
        instance_variable_set("@#{collection_name}", collection_value)
      end
    end

    class << self
      def attr_collection(name, **options)
        unless name.is_a?(Symbol) || name.is_a?(String)
          raise ArgumentError.new("collection's name must be a Symbol or a String")
        end
        representer_name = \
          options[:representer_name] ? options[:representer_name] : guess_representrer_name(name.to_s)
        raise ArgumentError.new("representer_name must be a String") unless representer_name.is_a?(String)
        begin
          representer = representer_name.constantize
          collections[name.to_sym] = representer
        rescue NameError => e
          collections[name.to_sym] = nil
        end
        class_eval do
          attr_reader name.to_sym
        end
      end

      def collection_names
        collections.keys
      end

      def guess_representrer_name(name)
        "#{name.singularize.camelize}Representer"
      end
    end
  end
end
