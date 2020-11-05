# frozen_string_literal: true

module GraphAuthentication
  extend ActiveSupport::Concern

  included do
    def session
      @session ||= context[:session]
    end

    def current_user
      @current_user ||= context[:current_user]
    end

    def current_user!
      current_user || raise(GraphQL::ExecutionError, "Not Authenticated")
    end
  end
end
