# frozen_string_literal: true

module JSONAttributable
  extend ActiveSupport::Concern
  include ActiveModel::AttributeMethods
  include ActiveModel::Model

  class_methods do
    def attribute_names
      @attribute_names ||= []
    end

    def attribute(name)
      attribute_names.push(name)
      attr_accessor(name)
    end

    def binary?
      false
    end

    def cast(value)
      return value if value.is_a?(self)

      new(value.to_h)
    end

    def changed_in_place?(raw_old_value, new_value)
      new_value.as_json != deserialize(raw_old_value).as_json
    end

    def deserialize(value)
      cast(value.nil? ? nil : JSON.parse(value))
    end

    def serialize(value)
      value.as_json.except(:errors, :validation_context).to_json
    end

    def type
      :json
    end
  end

  included do
    def [](key)
      instance_variable_get("@#{key}")
    end

    def []=(key, value)
      instance_variable_set("@#{key}", value)
    end

    def to_h
      self.class.attribute_names.index_with { |a| send(a) }
    end
  end
end
