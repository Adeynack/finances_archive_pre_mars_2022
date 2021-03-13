# frozen_string_literal: true

module Registers
  class BankInfo
    include JSONAttributable

    attribute :account_number
    attribute :iban

    validates :account_number, type: :string
    validates :iban, iban: { allow_nil: true }
  end
end
