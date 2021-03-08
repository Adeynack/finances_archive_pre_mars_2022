# frozen_string_literal: true

class CreateCreditCards < ActiveRecord::Migration[6.0]
  def change
    create_table :credit_cards, id: :uuid do |t|
      t.timestamps
      t.string :card_number
      t.datetime :expires_at
      t.integer :limit
    end
  end
end
