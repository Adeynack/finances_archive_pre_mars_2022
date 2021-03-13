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
#  initial_balance     :integer          default(0), not null
#  active              :boolean          default(TRUE), not null
#  default_category_id :bigint           indexed
#  info                :jsonb
#
class Register < ApplicationRecord
  include Currencyable
  using HashRefinements

  belongs_to :book
  belongs_to :parent, class_name: "Register", optional: true, inverse_of: :children

  has_one :default_category, class_name: "Register", required: false, dependent: false

  has_many :children, class_name: "Register", foreign_key: "parent_id", inverse_of: :parent, dependent: :destroy

  has_currency :currency

  scope :root, -> { where(parent: nil) }

  before_validation do
    info.minimize_presence!
  end

  before_create do
    self.starts_at ||= DateTime.now
    self.currency_iso_code ||= book.default_currency_iso_code
  end

  class << self
    def store_full_sti_class
      false
    end

    def find_sti_class(type_name)
      super("Registers::#{type_name}")
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
  end
end
