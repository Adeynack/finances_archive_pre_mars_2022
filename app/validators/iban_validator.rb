# frozen_string_literal: true

class IBANValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.blank?
      record.errors.add(attribute, :cannot_be_empty) unless options[:allow_nil]
      return
    end

    return if IBANTools::IBAN.valid?(value)

    record.errors.add(attribute, record.errors.generate_message(attribute, :invalid))
  end
end
