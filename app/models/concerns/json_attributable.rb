# frozen_string_literal: true

# A way of typing JSON fields inside of models.
# Inspired from @JensRavens code (https://github.com/jensravens)
module JSONAttributable
  extend ActiveSupport::Concern
  include ActiveModel::Model
  using HashRefinements

  class_methods do
    def assert_valid_value(_value)
      # puts "--> assert_valid_value(#{_value})"
    end

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

    def changed?(*_args)
      # puts "--> changed?(#{_args})"
      false
    end

    def changed_in_place?(raw_old_value, new_value)
      # puts "--> changed_in_place?(#{raw_old_value}, #{new_value})"
      new_value.as_json != deserialize(raw_old_value).as_json
    end

    def deserialize(value)
      cast(value.nil? ? nil : JSON.parse(value))
    end

    def serialize(value)
      serialized = value.as_json.except(:errors, :validation_context)
      serialized.minimize_presence!.presence if @minimize_presence
      serialized&.to_json
    end

    def type
      :json
    end
  end

  included do
    @minimize_presence = true

    attr_accessor :errors
    attr_accessor :validation_context

    def initialize(value)
      super(value)
      @errors = ActiveModel::Errors.new(self)
    end

    def [](key)
      instance_variable_get("@#{key}")
    end

    def []=(key, value)
      instance_variable_set("@#{key}", value)
    end

    def to_h
      self.class.attribute_names.index_with { |a| send(a) }
    end

    def attributes
      self.class.attribute_names.map { |name| [name.to_s, send(name)] }.to_h
    end
  end
end
