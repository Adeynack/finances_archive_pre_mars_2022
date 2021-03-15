# frozen_string_literal: true

class CreateReminders < ActiveRecord::Migration[6.1]
  def change
    add_enum_value :register_type, "Reminder"
    add_reference :books, :reminder_register, foreign_key: { to_table: :registers }
    create_enum :reminder_mode, [:manual, :auto_commit, :auto_cancel]
    create_table :reminders do |t|
      t.timestamps
      t.references :book, foreign_key: true, null: false
      t.string :title, null: false
      t.text :description
      t.enum :mode, as: :reminder_mode, null: false, default: :manual
      t.tsrange :during, null: false, comment: "Can be open end, but must have a start date."
      t.string :recurrence, comment: "For one-shot reminders, nil, happening only on beginning of `during`."
      t.string :last_commit_at, comment: "Last time this reminder was committed. `nil` means it never was."
      t.references :transaction, foreign_key: true, null: false
    end
  end
end
