# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    def enum_sym(definitions)
      if definitions.is_a?(Hash) && definitions.length == 1
        enum_name, enum_values = definitions.first
        if enum_values.is_a?(Array) && enum_values.all? { |v| v.is_a?(String) || v.is_a?(Symbol) }
          enum_values_hash = enum_values.map { |v| [v.to_sym, v.to_s] }.to_h
          enum(enum_name => enum_values_hash)
          return
        end
      end

      raise ArgumentError, "expecting a only entry Hash with 'name_of_the_enum: [:possible, :values, :as, :symbol, \"or\", \"string\"]'"
    end
  end
end
