# frozen_string_literal: true

module GraphQLHelper
  def session
    @session ||= {}
  end

  def login(user)
    session[:user_id] = user.id
  end

  attr_reader :result

  delegate :data, to: :result

  def gql(query, variables: {}, expect_errors: false)
    @result = nil

    current_user = LazyObject.new { User.find(session[:user_id]) } if session[:user_id].present?
    context = {
      session: session,
      current_user: current_user
    }
    result = FinancesSchema.execute(query, context: context, variables: variables)
    raise "GraphQL Error(s): #{result['errors'].to_json}" unless expect_errors || result["errors"].blank?

    @result = JSON.parse(result.to_json, object_class: OpenStruct)
  end
end

RSpec.configure do |config|
  config.include GraphQLHelper, type: :graph
end
