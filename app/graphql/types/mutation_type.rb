# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :logout, mutation: Mutations::Logout
    field :login, mutation: Mutations::Login
  end
end
