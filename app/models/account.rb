# frozen_string_literal: true

# == Schema Information
#
# Table name: registers
#
#  id              :uuid             not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  book_id         :uuid             not null
#  parent_id       :uuid
#  name            :string           not null
#  type            :string           not null
#  info            :jsonb
#  notes           :string
#  currency_id     :uuid             not null
#  initial_balance :integer          not null
#  active          :boolean          default(TRUE), not null
#
class Account < Register
  KNOWN_TYPES = Register.list_register_classes(name)

  validate :validate_parent_is_account

  protected

  def validate_parent_is_account
    errors.add :parent, "has to be another account or null" unless parent.nil? || parent.is_a?(Account)
  end
end
