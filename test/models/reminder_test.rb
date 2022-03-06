# frozen_string_literal: true

# == Schema Information
#
# Table name: reminders
#
#  id                   :bigint           not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  book_id              :bigint           not null, indexed
#  title                :string           not null
#  description          :text
#  mode                 :enum             default("manual"), not null
#  first_date           :date             not null
#  last_date            :date
#  recurrence           :jsonb
#  last_commit_at       :date
#  next_occurence_at    :date
#  exchange_register_id :bigint           not null, indexed
#  exchange_description :string           not null
#  exchange_memo        :text
#  exchange_status      :enum             default("uncleared"), not null
#
require "test_helper"

class ReminderTest < ActiveSupport::TestCase
  test "create a reminder with a recurence" do
    book = books(:joe)
    first_bank = registers(:first_bank)
    reminder = book.reminders.create!(
      title: "Test 1",
      last_date: nil,
      exchange_description: "Reminder Exchange Template",
      exchange_register: first_bank,
      recurrence: Montrose.every(:year, mday: 7, month: :january)
    )
    assert_equal Time.zone.today, reminder.first_date
    assert Time.zone.today, reminder.next_occurence_at.year >= Time.zone.today.year
    assert_equal 1, reminder.next_occurence_at.month
    assert_equal 7, reminder.next_occurence_at.day
  end

  test "create a reminder with no recurence" do
    book = books(:joe)
    first_bank = registers(:first_bank)
    reminder = book.reminders.create!(
      title: "Test 1",
      last_date: nil,
      exchange_description: "Reminder Exchange Template",
      exchange_register: first_bank
    )
    # first_date defaults to today when not specified
    assert_equal Time.zone.today, reminder.first_date
  end

  test "create a reminder passing IDs for register and book" do
    book = books(:joe)
    first_bank = registers(:first_bank)
    Reminder.create!(
      book_id: book.id,
      exchange_register_id: first_bank.id,
      title: "Bleh",
      exchange_description: "Foo"
    )
  end

  test "fails if the register does not belong to the same book" do
    book = books(:joe)
    other_register = registers(:blood_bank)
    error = assert_raise(ActiveRecord::RecordInvalid) do
      book.reminders.create!(
        title: "Test 1",
        exchange_description: "Reminder Exchange Template",
        exchange_register: other_register
      )
    end
    assert_equal "Validation failed: Exchange register must belong to the same book as the reminder", error.message
  end
end
