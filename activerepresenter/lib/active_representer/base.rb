# frozen_string_literal: true

require "active_model"
require "active_support"

module ActiveRepresenter
  class Base
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :wrapped
    class_attribute :collections, default: {}

    delegate_missing_to :wrapped

    def self.wrap(wrapped)
      instance = new
      instance.wrapped = wrapped

      collection_names.each do |collection_name|
        next if wrapped[collection_name].nil?
        representer_klass = collections[collection_name]
        collection_value = \
          if representer_klass
            wrapped[collection_name].map { |item| representer_klass.wrap(item) }
          else
            wrapped[collection_name]
          end
        instance.instance_variable_set("@#{collection_name}", collection_value)
      end

      attribute_names.each do |attribute_name|
        instance.send("#{attribute_name}=", wrapped.send(attribute_name))
      end

      instance
    end

    def self.attr_field(name, type = Type::Value.new, **options)
      attribute(name, type, **options)
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
        collections[name.to_sym] = representer
      rescue NameError => e
        collections[name.to_sym] = nil
      end

      class_eval do
        attr_reader name.to_sym
      end
    end

    def self.collection_names
      collections.keys
    end

    def self.attribute_names
      attribute_types.keys - ["wrapped"]
    end

    def self.guess_representrer_name(name)
      "#{name.singularize.camelize}Representer"
    end
  end
end
