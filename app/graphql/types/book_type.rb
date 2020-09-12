# frozen_string_literal: true

module Types
  class BookType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :owner, UserType, null: false
    field :book_rights, [BookRightType], null: false
    # field :accounts, [AccountType], null: false
    field :categories, [CategoryType], null: false
  end
end
