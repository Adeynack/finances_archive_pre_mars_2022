# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mutations::Logout, type: :graph do
  fixtures :users

  let(:me_query) do
    <<~GQL
      {
        me {
          id
        }
      }
    GQL
  end

  let(:logout_query) do
    <<~GQL
      mutation Logout {
        logout(input: {}) {
          clientMutationId
        }
      }
    GQL
  end

  it "succeeds when no user is logged in" do
    gql me_query
    expect(data.me).to be_nil

    gql logout_query
    expect(data.logout).not_to be_nil

    gql me_query
    expect(data.me).to be_nil
  end

  it "succeeds when a user is logged in" do
    login :mary

    gql me_query
    expect(data.me.id).to eq users(:mary).id

    gql logout_query
    expect(data.logout).not_to be_nil

    gql me_query
    expect(data.me).to be_nil
  end
end
