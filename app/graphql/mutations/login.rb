# frozen_string_literal: true

module Mutations
  class Login < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true

    field :me, Types::CurrentUserType, null: true, description: "The current logged in user, or null if the login failed (wrong email and/or password)."

    def resolve(email:, password:)
      user = User.find_by(email: email)&.authenticate(password) || nil
      if user
        session[:user_id] = user.id
        context[:current_user] = user
      end
      { me: user }
    end
  end
end
