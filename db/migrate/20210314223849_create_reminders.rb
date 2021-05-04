# frozen_string_literal: true

class CreateReminders < ActiveRecord::Migration[6.1]
  def change
    create_enum :reminder_mode, [:manual, :auto_commit, :auto_cancel]
    create_table :reminders do |t|
      t.timestamps
      t.references :book, foreign_key: true, null: false
      t.string :title, null: false
      t.text :description
      t.enum :mode, as: :reminder_mode, null: false, default: :manual
      t.date :first_date, null: false, comment: "From when to apply the reminder."
      t.date :last_date, comment: "Until when to apply the reminder (optional)."
      t.string :recurrence, comment: "Expressed as a 'Montrose' string. For one-shot reminders, nil, happening only on beginning of `during`."
      t.string :last_commit_at, comment: "Last time this reminder was committed. `nil` means it never was."
      # Transaction Template
      t.references :transaction_register, foreign_key: { to_table: :registers }, null: false, comment: "From which register does the money come from."
      t.string :transaction_description, null: false, comment: "Label of the transaction."
      t.text :transaction_memo, comment: "Detail about the transaction."
      t.enum :transaction_status, as: :transaction_status, null: false, default: "uncleared"
    end
    create_table :reminder_splits do |t|
      t.timestamps
      t.references :reminder, foreign_key: true, null: false
      t.references :register, foreign_key: true, null: false, comment: "To which register is the money going to for this split."
      t.integer :amount, null: false
      t.integer :counterpart_amount, comment: "Amount in the destination register, if it differs from 'amount' (ex: an exchange rate applies)."
      t.text :memo, comment: "Detail about the transaction, to show in the destination register."
      t.enum :status, as: :transaction_status, null: false, default: "uncleared"
    end
  end
end
