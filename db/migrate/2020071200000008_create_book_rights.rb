# frozen_string_literal: true

class CreateBookRights < ActiveRecord::Migration[6.0]
  def change
    create_table :book_rights, id: :uuid do |t|
      t.timestamps
      t.references :book, null: true, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :access, null: false

      t.index [:book_id, :user_id], unique: true
    end
  end
end
