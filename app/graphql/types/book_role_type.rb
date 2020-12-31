# frozen_string_literal: true

module Types
  class BookRoleType < Types::BaseObject
    field :role, BookRoleNameType, null: false
    field :effective_roles, [BookRoleNameType], null: false

    belongs_to :book, BookType
    belongs_to :user, UserType
  end
end
