# frozen_string_literal: true

require "active_model"
require "active_support"

module ActiveRepresenter
  # == Action \Representer \Base
  #
  # This is a base class for a representer (wrapped object).
  # It wraps the original object as `wrapped` attribute and
  # you can add custom methods to the class (using the decorator pattern).
  #
  # In addition, `attr_field` / `attr_collection` can be used for attributes.
  #
  # attr_field:
  #   Declare additional field and type to the objects.
  #   You can get / set field's value (converted to corresponding).
  #   It uses ActiveModel::Attributes internally.
  #   See examples: AttrFieldTest in test/attr_field_test.
  #
  # attr_collection:
  #   Declare sub (containing) object array like has many association.
  #   If sub object's representer is found, sub objects will be wrapped by it.
  #   See examples: AttrCollectionTest in test/attr_collection_test.
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
