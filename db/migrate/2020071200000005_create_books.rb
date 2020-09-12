# frozen_string_literal: true

class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books, id: :uuid do |t|
      t.timestamps
      t.string :name, null: false
      t.references :owner, type: :uuid, null: false, foreign_key: { to_table: :users }
      t.string :default_currency_iso_code

      t.index [:name, :owner_id], unique: true
    end
  end
end
