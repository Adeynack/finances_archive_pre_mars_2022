# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mutations::Login, type: :graph do
  fixtures :users

  let(:login_query) do
    <<~GQL
      mutation Login($email: String!, $password: String!) {
        login(input: { email: $email, password: $password }) {
          me {
            id
            email
            displayName
          }
        }
      }
    GQL
  end

  it "succeeds with no 'me' user when email does not exist" do
    gql login_query, variables: { email: "abc@donotexist.net", password: "ABC" }
    expect(data.me).to be_nil
  end

  it "succeeds with no 'me' user when email exists, but password is wrong" do
    gql login_query, variables: { email: users(:joe).email, password: "foo" }
    expect(data.me).to be_nil
  end

  it "succeeds with a 'me' user when credentials are valid" do
    joe = users(:joe)
    gql login_query, variables: { email: joe.email, password: "joe" }
    me = data.login.me
    expect(me.id).to eq joe.id
    expect(me.email).to eq joe.email
    expect(me.displayName).to eq joe.display_name
  end
end
