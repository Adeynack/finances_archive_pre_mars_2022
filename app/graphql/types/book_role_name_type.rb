# frozen_string_literal: true

module Types
  class BookRoleNameType < Types::BaseEnum
    BookRoleDefinition.all.each do |role|
      value role.name.upcase,
            role.description,
            value: role.name
    end
  end
end
