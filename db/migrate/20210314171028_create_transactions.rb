# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_enum "transaction_status", ["uncleared", "reconciling", "cleared"]
    create_table :transactions do |t|
      t.timestamps
      t.date :date, null: false, comment: "Date the transaction appears in the book."
      t.references :register, foreign_key: true, null: false, comment: "From which register does the money come from."
      t.string :cheque, comment: "Cheque information."
      t.string :description, null: false, comment: "Label of the transaction."
      t.text :memo, comment: "Detail about the transaction."
      t.enum :status, as: :transaction_status, null: false, default: "uncleared"

      t.index :date
    end
  end
end
