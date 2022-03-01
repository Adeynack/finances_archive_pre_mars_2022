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
#  currency_iso_code   :string(3)        not null
#  notes               :text
#  initial_balance     :integer          default(0), not null
#  active              :boolean          default(TRUE), not null
#  default_category_id :bigint           indexed
#  info                :jsonb
#
require "test_helper"

class CardTest < ActiveSupport::TestCase
  test "info is all nil by default" do
    card = Card.create! name: "Visa", book: Book.take
    assert_nil card.account_number
    assert_nil card.iban
    assert_nil card.interest_rate
    assert_nil card.credit_limit
    assert_nil card.card_number
    assert_nil card.expires_at
  end

  test "numeric account number is coerced into a string" do
    card = Card.create! name: "Visa", book: Book.take, account_number: 123
    assert_equal "123", card.account_number
  end

  test "cannot create a card when IBAN is not valid" do
    error = assert_raise(ActiveRecord::RecordInvalid) do
      Card.create! name: "Visa", book: Book.take, iban: "foo"
    end
    assert_equal "Validation failed: IBAN is invalid", error.message
  end

  test "can create a card when IBAN is valid" do
    card = Card.create! name: "Visa", book: Book.take, iban: "SE35 5000 0000 0549 1000 0003"
    assert card.valid?
  end

  test "cannot create a card when the interest rate is not a number" do
    error = assert_raise(ActiveRecord::RecordInvalid) do
      Card.create! name: "Visa", book: Book.take, interest_rate: "foo"
    end
    assert_equal "Validation failed: Interest rate is not a number", error.message
  end

  test "can create a card when the interest rate is coercable into a number" do
    card = Card.create! name: "Visa", book: Book.take, interest_rate: "123.435"
    assert card.valid?
    assert_equal Float, card.interest_rate.class
    assert_equal 123.435, card.interest_rate
  end

  test "can create a card when the expires_at is a valid date string" do
    card = Card.create! name: "Visa", book: Book.take, expires_at: "2022-06-01"
    assert card.valid?
    assert_equal "2022-06-01", card.expires_at
  end

  test "can create a card when the expires_at is a date object" do
    card = Card.create! name: "Visa", book: Book.take, expires_at: Date.parse("2022-06-02")
    assert card.valid?
    assert_equal "2022-06-02", card.expires_at
  end
end
