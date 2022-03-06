# frozen_string_literal: true

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
