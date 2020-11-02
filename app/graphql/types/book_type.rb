# frozen_string_literal: true

module Types
  class BookType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :owner, UserType, null: false # TODO: use loader to avoid N+1 queries
    field :roles, [BookRoleType], null: false # TODO: use loader to avoid N+1 queries
    def roles
      object.book_roles
    end
    # field :accounts, [AccountType], null: false
    # field :categories, [CategoryType], null: false
  end
end
