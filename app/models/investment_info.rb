# frozen_string_literal: true

class InvestmentInfo
  include JSONAttributable

  attribute :account_number, string: {allow_nil: true}
end
