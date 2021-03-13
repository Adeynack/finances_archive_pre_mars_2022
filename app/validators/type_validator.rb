# frozen_string_literal: true

# Validates that the value, if present, is a string.
class TypeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # ap { attribute: attribute, value: value, options: options }
    return if value.nil?

    allowed_types = Array.wrap(options[:with] || options[:in]).flat_map do |type|
      next type if type.is_a?(Class)

      SYMBOL_TYPES[type] || raise(ArgumentError, "type #{type} is not recognized by the type validator")
    end
    return if allowed_types.include?(value.class)

    record.errors.add(attribute, "must be #{allowed_types.join(' or ')}")
  end

  SYMBOL_TYPES = {
    array: Array,
    big_decimal: BigDecimal,
    boolean: [TrueClass, FalseClass],
    date: Date,
    datetime: DateTime,
    float: Float,
    hash: Hash,
    integer: Integer,
    number: [Integer, Float, BigDecimal],
    string: String,
    symbol: Symbol,
    time: Time
  }.freeze
end
