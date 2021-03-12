# frozen_string_literal: true

module Registers
  class BankInfo
    include JSONAttributable

    attribute :account_number
    attribute :iban
  end
end
