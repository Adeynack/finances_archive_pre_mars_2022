# frozen_string_literal: true

class SeedKnownCurrencies < ActiveRecord::Migration[6.0]
  def up
    # TODO: #1: Find a better way to seed this information
    Currency.seed_known_currencies
  end
end
