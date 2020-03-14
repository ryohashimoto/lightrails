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
    class_attribute :ones, default: {}
    class_attribute :collections, default: {}

    delegate_missing_to :wrapped

    def self.wrap(wrapped)
      instance = new
      instance.wrapped = wrapped

      one_names.each do |one_name|
        next if wrapped[one_name].nil?
        representer_klass = ones[one_name]
        one_value = \
          if representer_klass
            representer_klass.wrap(wrapped[one_name])
          else
            wrapped[one_name]
          end
        instance.instance_variable_set("@#{one_name}", one_value)
      end

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

    def self.attr_one(name, **options)
      check_name_type(name)
      representer_name = specify_or_guess_representer_name(options[:representer_name], name)

      begin
        representer = representer_name.constantize
        ones[name.to_sym] = representer
      rescue NameError => e
        ones[name.to_sym] = nil
      end

      class_eval do
        attr_reader name.to_sym
      end
    end

    def self.attr_collection(name, **options)
      check_name_type(name)
      representer_name = specify_or_guess_representer_name(options[:representer_name], name)

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

    def self.one_names
      ones.keys
    end

    def self.collection_names
      collections.keys
    end

    def self.attribute_names
      attribute_types.keys - ["wrapped"]
    end

    def self.check_name_type(name)
      unless name.is_a?(Symbol) || name.is_a?(String)
        raise ArgumentError.new("collection's name must be a Symbol or a String")
      end
    end

    def self.guess_representrer_name(name)
      "#{name.singularize.camelize}Representer"
    end

    def self.specify_or_guess_representer_name(specified_name, wrapped_name)
      specified_name ? specified_name.to_s : guess_representrer_name(wrapped_name.to_s)
    end
  end
end
