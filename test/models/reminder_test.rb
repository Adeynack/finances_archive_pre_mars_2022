# == Schema Information
#
# Table name: reminders
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  book_id        :bigint           not null, indexed
#  title          :string           not null
#  description    :text
#  mode           :enum             default("manual"), not null
#  during         :tsrange          not null
#  recurrence     :string
#  last_commit_at :string
#  transaction_id :bigint           not null, indexed
#
require "test_helper"

class ReminderTest < ActiveSupport::TestCase
  test "create a reminder" do
    book = Book.create! name: "Test Book", owner: User.first, default_currency_iso_code: "eur"
    book.create_reminder_register!
    reminder_transaction = book.reminder_register.transactions.create! description: "Reminder Transaction Template"
    ap reminder_transaction
    binding.pry
    reminder1 = book.reminders.create! title: "Test 1", during: DateTime.now.., transaction_id: reminder_transaction.id
  end
end
