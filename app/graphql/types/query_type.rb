# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :me, CurrentUserType, null: true, description: "Currently logged in user."
    def me
      current_user
    end
  end
end
