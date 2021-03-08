# frozen_string_literal: true

class CreateBookRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :book_roles, id: :uuid do |t|
      t.timestamps
      t.references :book, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :role, null: false

      t.index [:book_id, :user_id], unique: true
    end
  end
end
