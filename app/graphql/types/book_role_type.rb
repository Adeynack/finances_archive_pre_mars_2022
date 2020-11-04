# frozen_string_literal: true

module Types
  class BookRoleType < Types::BaseObject
    field :book, BookType, null: false, load_association: true
    field :user, UserType, null: false, load_association: true
    field :role, BookRoleNameType, null: false
    field :effective_roles, [BookRoleNameType], null: false
  end
end
