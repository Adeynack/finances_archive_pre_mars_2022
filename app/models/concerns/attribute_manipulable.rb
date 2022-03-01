# frozen_string_literal: true

module AttributeManipulable
  extend ActiveSupport::Concern

  COERCIONS = {
    String: ->(v) { v.to_s },
    Integer: ->(v) { v.to_i },
    Float: ->(v) { v.to_f },
    BigDecimal: ->(v) { v.to_d },
    min_hash: ->(v) do
      v.filter { |_k, v| v.present? || v.is_a?(FalseClass) }
    end
  }.freeze

  class_methods do
    def coerce_attribute(*attributes, to:, allow_nil: true)
      to = to.name.to_sym if to.is_a?(Class)
      attributes.each do |attribute|
        raise ArgumentError, "No coercion exists for #{to}" unless COERCIONS.key?(to)

        before_save do
          instance_exec do
            raw_value = send(attribute)
            coerced_value = COERCIONS[to].call(raw_value) if raw_value.present? || raw_value.is_a?(FalseClass) || !allow_nil
            send(:"#{attribute}=", coerced_value)
          end
        end
      end
    end
  end
end
