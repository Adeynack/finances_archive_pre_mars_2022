# frozen_string_literal: true

module Types::Register
  module AccountType
    include Types::BaseInterface

    field :book, Types::BookType, null: false
    field :parent, Types::Register::AccountType, null: true
    field :name, String, null: false
    field :type, String, null: false
    field :notes, String, null: false
    # field :currency, Types::CurrencyType, null: false
    field :active, Boolean, null: false
  end
end
