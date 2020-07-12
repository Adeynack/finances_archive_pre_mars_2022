# frozen_string_literal: true

# == Schema Information
#
# Table name: currencies
#
#  id              :uuid             not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  iso_code        :string
#  name            :string           not null
#  symbol          :string
#  symbol_first    :boolean          not null
#  subunit         :string
#  subunit_to_unit :integer          not null
#
class Currency < ApplicationRecord
  has_many :registers, dependent: :restrict_with_exception
  has_many :books, inverse_of: :default_currency, dependent: :restrict_with_exception # TODO: 1: How to make this relation work?

  validates :name, presence: true

  class << self
    # Upsert the known currencies into the database.
    # Useful to:
    #   - initially fill the database with currencies from the Gem
    #   - add new currencies if any are added to the Gem
    def seed_known_currencies
      Currency.transaction do
        Money::Currency.all.each do |c| # rubocop:disable Rails/FindEach
          attributes = {
            name: c.name,
            symbol: c.symbol.presence,
            symbol_first: c.symbol_first,
            subunit: c.subunit.presence,
            subunit_to_unit: c.subunit_to_unit
          }
          Currency.find_or_create_by(iso_code: c.iso_code).update!(attributes)
        end
      end
    end
  end
end
