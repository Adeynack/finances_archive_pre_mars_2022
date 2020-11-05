# frozen_string_literal: true

module Types
  class BaseObject < GraphQL::Schema::Object
    include GraphAuthentication
    include GraphFieldHelper

    field_class Types::BaseField
  end
end
