# frozen_string_literal: true

class DateStringValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.is_a?(Date)

    allow_nil = options[:allow_nil]
    if value.blank?
      record.errors.add(attribute, :cannot_be_empty) unless allow_nil
      return
    end

    value_as_date = as_date(value)
    record.errors.add(attribute, :is_not_a_date_string) if value_as_date.nil?
  end

  private

  def as_date(value)
    Date.parse(value)
  rescue Date::Error
    nil
  end
end
