# frozen_string_literal: true

module Types
  class CurrentUserType < UserType
    model User

    has_many :books, BookType, description: "Books owner by the current user."
    has_many :book_roles, BookRoleType, description: "Roles the current user has on books."
  end
end
