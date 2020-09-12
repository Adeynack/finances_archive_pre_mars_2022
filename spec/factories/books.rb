# frozen_string_literal: true

# == Schema Information
#
# Table name: books
#
#  id                        :uuid             not null, primary key
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  name                      :string           not null
#  owner_id                  :uuid             not null
#  default_currency_iso_code :string
#
FactoryBot.define do
  factory :book do
    name { Faker::Lorem.unique.sentences(number: 1)[0] }
  end
end
