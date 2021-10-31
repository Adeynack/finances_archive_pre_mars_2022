# frozen_string_literal: true

# == Schema Information
#
# Table name: registers
#
#  id                  :bigint           not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  name                :string           not null
#  type                :enum             not null
#  book_id             :bigint           not null, indexed
#  parent_id           :bigint           indexed
#  starts_at           :date             not null
#  currency_iso_code   :string(3)        not null
#  notes               :text
#  initial_balance     :integer          default(0), not null
#  active              :boolean          default(TRUE), not null
#  default_category_id :bigint           indexed
#  info                :jsonb
#
class Register < ApplicationRecord
  include Currencyable
  include Taggable
  include Importable

  belongs_to :book
  has_closure_tree order: :name

  has_one :default_category, class_name: "Register", required: false, dependent: false

  has_many :reminders, dependent: :restrict_with_error, foreign_key: "exchange_register_id", inverse_of: :exchange_register

  # Exchanges originating from this register.
  # THIS REGISTER --> Exchange --> Splits --> Other Registers
  has_many :exchanges, dependent: :destroy

  # Splits pointing to this register. NOT splits of this register's exchanges.
  # Other Register --> Exchange --> Split --> THIS REGISTER
  has_many :splits, dependent: :destroy

  has_currency :currency

  scope :accounts, -> { where(type: Register.account_type_names) }
  scope :categories, -> { where(type: Register.category_type_names) }

  validates :info, bubble_up: true

  before_create do
    self.starts_at ||= Time.zone.today
    self.currency_iso_code ||= book.default_currency_iso_code
  end

  class << self
    def store_full_sti_class
      # save 'Asset' to the DB instead of 'Registers::Asset'
      false
    end

    def find_sti_class(type_name)
      # avoiding string building and regex computation by bypassing it here by a direct hash lookup
      type_name_to_sti_class[type_name]
    end

    def type_name_to_sti_class
      @type_name_to_sti_class ||= all_types.index_by { |t| t.name.demodulize }
    end

    def all_types
      @all_types ||= account_types + category_types
    end

    def account_types
      @account_types ||= [
        Registers::Asset,
        Registers::Bank,
        Registers::Card,
        Registers::Institution,
        Registers::Investment,
        Registers::Liability,
        Registers::Loan,
      ]
    end

    def category_types
      @category_types ||= [
        Registers::Expense,
        Registers::Income,
      ]
    end

    def account_type_names
      @account_type_names ||= account_types.map(&:sti_name)
    end

    def category_type_names
      @category_type_names ||= category_types.map(&:sti_name)
    end
  end
end
