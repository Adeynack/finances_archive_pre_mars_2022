# frozen_string_literal: true

class CreateBankAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :bank_accounts, id: :uuid do |t|
      t.timestamps
      t.string :bank_name
      t.string :account_number
    end
  end
end
