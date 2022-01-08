# frozen_string_literal: true

# Validates an associated attribute and bubles up its error to the actual model.
# Inspired from this post: https://stackoverflow.com/a/7387710/1435116
#
# Why not use `validates_assiciated`?
# Because it does not tell the caller what, inside of the value, did not validate.
#
class BubbleUpValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.nil?
    return if value.valid?

    value.errors.full_messages.each do |msg|
      record.errors.add(attribute, "/ #{msg}", **options.merge(value:))
    end
  end
end
