# frozen_string_literal: true

# == Schema Information
#
# Table name: reminders
#
#  id                      :bigint           not null, primary key
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  book_id                 :bigint           not null, indexed
#  title                   :string           not null
#  description             :text
#  mode                    :enum             default("manual"), not null
#  first_date              :date             not null
#  last_date               :date
#  recurrence              :string
#  last_commit_at          :string
#  transaction_register_id :bigint           not null, indexed
#  transaction_description :string           not null
#  transaction_memo        :text
#  transaction_status      :enum             default("uncleared"), not null
#
require "test_helper"

class ReminderTest < ActiveSupport::TestCase
  test "create a reminder" do
    book = Book.create! name: "Test Book", owner: User.first, default_currency_iso_code: "eur"
    first_bank = book.registers.create! name: "First Bank", type: "Bank"
    reminder = book.reminders.create!(
      title: "Test 1",
      last_date: nil,
      transaction_description: "Reminder Transaction Template",
      transaction_register: first_bank
    )
    # first_date defaults to today when not specified
    assert_equal Time.zone.today, reminder.first_date
  end

  test "create a reminder passing IDs for register and book" do
    book = Book.create! name: "Test Book", owner: User.first, default_currency_iso_code: "eur"
    first_bank = book.registers.create! name: "First Bank", type: "Bank"
    Reminder.create!(
      book_id: book.id,
      transaction_register_id: first_bank.id,
      title: "Bleh",
      transaction_description: "Foo"
    )
  end

  test "fails if the register does not belong to the same book" do
    book = Book.create! name: "Test Book", owner: User.first, default_currency_iso_code: "eur"
    other_book = Book.create! name: "Other Book", owner: User.first, default_currency_iso_code: "eur"
    first_bank = other_book.registers.create! name: "First Bank", type: "Bank"
    error = assert_raise(ActiveRecord::RecordInvalid) do
      book.reminders.create!(
        title: "Test 1",
        transaction_description: "Reminder Transaction Template",
        transaction_register: first_bank
      )
    end
    assert_equal "Validation failed: Transaction register must belong to the same book as the reminder", error.message
  end
end
