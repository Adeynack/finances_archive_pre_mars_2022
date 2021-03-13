# frozen_string_literal: true

module Registers
  class BankInfo
    include JSONAttributable

    attribute :account_number, type: [:string, :integer]
    attribute :iban, iban: { allow_nil: true }
  end
end
