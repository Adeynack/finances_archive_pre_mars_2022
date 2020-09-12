# frozen_string_literal: true

class CreateRegisters < ActiveRecord::Migration[6.0]
  def change
    create_table :registers, id: :uuid do |t|
      t.timestamps
      t.references :book, type: :uuid, foreign_key: true, null: false
      t.references :parent, type: :uuid, foreign_key: { to_table: :registers }, null: true

      t.string :name, null: false
      t.string :type, null: false
      t.jsonb :info, comment: "A JSON structure containing details about the register. Different register type have different fields."
      t.text :notes

      t.string :currency_iso_code, comment: "ISO Code of the currency in which this register operates."
      t.integer :initial_balance, null: false, comment: "Balance when this register is entered in the system."

      t.boolean :active, null: false, default: true, comment: "Inactive registers stay in the system for historical purposes but are not displayed to the user by default."

      t.index :type
      t.index :active
      t.index [:book_id, :parent_id, :name], unique: true
    end
  end
end
