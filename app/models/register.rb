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
  include Classable
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

  # TODO: On sub-types without info, updating this field fails. It should fail because it has to be `null`, not because it does not have a `valid?` method. To re-create: Asset.first.update! info: { foo: "bar" }
  validates :info, bubble_up: true

  before_create do
    self.starts_at ||= Time.zone.today
    self.currency_iso_code ||= book.default_currency_iso_code
  end

  class << self
    def all_types
      @all_types ||= (account_types + category_types).freeze
    end

    def account_types
      @account_types ||= find_descendant_from_files(Account).sort_by(&:sti_name).freeze
    end

    def category_types
      @category_types ||= find_descendant_from_files(Category).sort_by(&:sti_name).freeze
    end

    def account_type_names
      @account_type_names ||= account_types.map(&:sti_name).freeze
    end

    def category_type_names
      @category_type_names ||= category_types.map(&:sti_name).freeze
    end
  end
end
