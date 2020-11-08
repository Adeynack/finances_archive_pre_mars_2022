# frozen_string_literal: true

module GraphQLHelper
  def session
    @session ||= {}
  end

  def login(user)
    user = users(user) if user.is_a?(Symbol)
    session[:user_id] = user.id
  end

  attr_reader :json
  attr_reader :result

  delegate :data, to: :result

  def gql(query, variables: {}, expect_errors: false)
    @json = nil
    @result = nil

    current_user = User.find(session[:user_id]) if session[:user_id].present?
    context = {
      session: session,
      current_user: current_user
    }
    response = FinancesSchema.execute(query, context: context, variables: variables)
    raise "GraphQL Error(s): #{response['errors'].to_json}" unless expect_errors || response["errors"].blank?

    @result = JSON.parse(response.to_json, object_class: OpenStruct)
  end
end

RSpec.configure do |config|
  config.include GraphQLHelper, type: :graph
end
