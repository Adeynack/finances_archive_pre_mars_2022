# frozen_string_literal: true

# == Schema Information
#
# Table name: registers
#
#  id                  :bigint           not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  name                :string           not null
#  type                :enum             not null
#  book_id             :bigint           not null, indexed
#  parent_id           :bigint           indexed
#  starts_at           :date             not null
#  expires_at          :date
#  currency_iso_code   :string(3)        not null
#  notes               :text
#  initial_balance     :bigint           default(0), not null
#  active              :boolean          default(TRUE), not null
#  default_category_id :bigint           indexed
#  institution_name    :string
#  account_number      :string
#  iban                :string
#  interest_rate       :decimal(, )
#  credit_limit        :bigint
#  card_number         :string
#
require "test_helper"

class CardTest < ActiveSupport::TestCase
  test "cannot create a card when IBAN is not valid" do
    error = assert_raise(ActiveRecord::RecordInvalid) do
      Card.create! name: "Visa", book: books(:joe), iban: "foo"
    end
    assert_equal "Validation failed: IBAN is invalid", error.message
  end

  test "can create a card when IBAN is valid" do
    card = Card.create! name: "Visa", book: books(:joe), iban: "SE35 5000 0000 0549 1000 0003"
    assert card.valid?
  end
end
