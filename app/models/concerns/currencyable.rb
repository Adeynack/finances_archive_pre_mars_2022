# frozen_string_literal: true

module Currencyable
  extend ActiveSupport::Concern

  puts "ℹ️  Currencyable"

  KNOWN_CURRENCY_ISO_CODES = Money::Currency.all.map(&:iso_code)

  class_methods do
    def has_currency(attribute_name, optional: true) # rubocop:disable Naming/PredicateName
      raise ArgumentError, "has_currency needs the symbol of the attribute representing the ISO code of a currency" unless attribute_name.is_a?(Symbol)

      model_attribute = :"#{attribute_name}_iso_code"
      instance_variable_name = :"@#{attribute_name}"

      # Capitalize the currency code.
      before_validation do
        public_send(attribute_name.to_sym)&.upcase!
      end

      # Ensure the currency is known.
      validates model_attribute,
                inclusion: {
                  in: KNOWN_CURRENCY_ISO_CODES,
                  allow_nil: true,
                  message: "%{value} is not a known currency ISO code" # rubocop:disable Style/FormatStringToken
                }

      # Money object getter
      puts "ℹ️  define_method #{attribute_name}"
      define_method attribute_name do
        iso_code = public_send model_attribute
        currency = instance_variable_get(instance_variable_name)
        currency = Money::Currency.new(iso_code) unless currency.iso_code == iso_code
        currency
      end

      # Money object setter
      puts "ℹ️  define_method #{attribute_name}="
      define_method :"#{attribute_name}=" do |new_value|
        raise ArgumentError, "#{attribute_name} cannot be nil" if optional && new_value.nil?
        raise ArgumentError, "#{attribute_name} expected to be of type #{Money::Currency.name}" unless new_value.nil? || new_value.is_a?(Money::Currency)

        instance_variable_set(instance_variable_name, new_value)
        public_send :"#{model_attribute}=", new_value.iso_code
      end
    end
  end
end
