# frozen_string_literal: true

class CreateSplits < ActiveRecord::Migration[6.1]
  def change
    create_table :splits do |t|
      t.timestamps
      t.references :transaction, foreign_key: true, null: false
      t.references :register, foreign_key: true, null: false, comment: "To which register is the money going to for this split."
      t.integer :amount, null: false
      t.integer :counterpart_amount, comment: "Amount in the destination register, if it differs from 'amount' (ex: an exchange rate applies)."
      t.text :memo, comment: "Detail about the transaction, to show in the destination register."
      t.enum :status, as: :transaction_status, null: false, default: "uncleared"
    end
  end
end
