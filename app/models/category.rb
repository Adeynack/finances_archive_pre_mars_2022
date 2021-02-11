# frozen_string_literal: true

# == Schema Information
#
# Table name: registers
#
#  id                :uuid             not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  book_id           :uuid             not null
#  parent_id         :uuid
#  name              :string           not null
#  type              :string           not null
#  info              :jsonb
#  notes             :text
#  currency_iso_code :string
#  initial_balance   :integer          default(0), not null
#  active            :boolean          default(TRUE), not null
#
class Category < Register
  KNOWN_TYPES = Register.list_register_classes(name)

  validate :validate_parent_is_category_of_same_type

  protected

  def validate_parent_is_category_of_same_type
    errors.add :parent, "has to be another category of the same type or null" unless parent.nil? || parent.type == type
  end
end
