# frozen_string_literal: true

module Types
  class BookType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false

    belongs_to :owner, UserType

    has_many :roles, BookRoleType, :book_roles
  end
end
