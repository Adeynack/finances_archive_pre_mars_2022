# frozen_string_literal: true

# == Schema Information
#
# Table name: registers
#
#  id                  :bigint           not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  name                :string           not null
#  type                :enum             not null
#  book_id             :bigint           not null, indexed
#  parent_id           :bigint           indexed
#  starts_at           :date             not null
#  currency_iso_code   :string(3)        not null
#  initial_balance     :integer          default(0), not null
#  active              :boolean          default(TRUE), not null
#  default_category_id :bigint           indexed
#  info                :jsonb
#
class Registers::Card < Register
  store :info, accessors: [
    :account_number,
    :iban,
    :interest_rate,
    :credit_limit,
    :card_number,
    :expires_at,
  ], coder: JSON

  validates :interest_rate, numericality: { allow_nil: true, greater_than_or_equal_to: 0 }
  validates :credit_limit, numericality: { allow_nil: true, only_integer: true, greater_than_or_equal_to: 0 }
  validates :expires_at, date_string: { allow_nil: true }
end
