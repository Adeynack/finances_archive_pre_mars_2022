# frozen_string_literal: true

class CreateRegisters < ActiveRecord::Migration[6.0]
  def change
    create_table :registers, id: :uuid do |t|
      t.timestamps
      t.references :book, foreign_key: true, null: false, type: :uuid
      t.string :name
      t.integer :initial_balance
      t.string :registerable_type
      t.uuid :registerable_id
    end
  end
end
