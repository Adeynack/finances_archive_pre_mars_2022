# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts, id: :uuid do |t|
      t.timestamps
      t.references :book, type: :uuid, foreign_key: true, null: false
      t.references :parent, type: :uuid, foreign_key: { to_table: :accounts }, null: true

      t.string :name, null: false
      t.column :type, :account_type, null: false
      t.jsonb :info, comment: "A JSON structure containing details about the account. Different account type have different fields."
      t.string :notes

      t.references :currency, type: :uuid, foreign_key: true, null: false, comment: "Currency in which this account operates."
      t.integer :initial_balance, null: false, comment: "Balance when this account is entered in the system."

      t.boolean :active, default: true, comment: "Inactive accounts stay in the system for historical purposes but are not displayed to the user by default."

      t.index :type
      t.index :active
      t.index [:book_id, :parent_id, :name], unique: true
    end
  end
end
