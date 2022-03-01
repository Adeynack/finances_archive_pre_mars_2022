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
#  notes               :text
#  initial_balance     :integer          default(0), not null
#  active              :boolean          default(TRUE), not null
#  default_category_id :bigint           indexed
#  info                :jsonb
#
class Card < Account
  store_accessor :info, :bank_name, :account_number, :iban, :interest_rate, :credit_limit, :card_number, :expires_at

  validates :iban, iban: {allow_nil: true}
  validates :interest_rate, numericality: {allow_nil: true}
  validates :credit_limit, numericality: {allow_nil: true, only_integer: true}
  validates :expires_at, date: {allow_nil: true}

  coerce_attribute :bank_name, :account_number, :card_number, to: String
  coerce_attribute :interest_rate, to: Float
  coerce_attribute :credit_limit, to: Integer
end
