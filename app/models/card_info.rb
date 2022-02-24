# frozen_string_literal: true

class CardInfo
  include JSONAttributable

  attribute :bank_name, string: {allow_nil: true}
  attribute :account_number, string: {allow_nil: true}
  attribute :iban, iban: {allow_nil: true}
  attribute :interest_rate, numericality: {allow_nil: true}
  attribute :credit_limit, numericality: {allow_nil: true, only_integer: true}
  attribute :card_number, string: {allow_nil: true}
  attribute :expires_at, date: {allow_nil: true}
end
