# frozen_string_literal: true

class CreateCurrencies < ActiveRecord::Migration[6.0]
  def change
    create_table :currencies, id: :uuid do |t|
      t.timestamps
      t.string :iso_code, comment: "ISO-4217 Code (https://en.wikipedia.org/wiki/ISO_4217)"
      t.string :name, null: false
      t.string :symbol, comment: "Text or symbol to prefix or suffix when displaying an amount in this currency."
      t.boolean :symbol_first, null: false, comment: "Indicates if the symbol prefixes (true) or suffixes (false) the amount."
      t.string :subunit, comment: "Name of sub-unit of the currency (if any)."
      t.integer :subunit_to_unit, null: false, comment: "How many sub-units does it take to make one unit (ex: 100 cents for 1 dollar, 5 Khoums for 1 Mauritanian Ouguiya)"

      t.index [:iso_code], unique: true
    end
  end
end
