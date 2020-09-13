# frozen_string_literal: true

# == Schema Information
#
# Table name: books
#
#  id                        :uuid             not null, primary key
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  name                      :string           not null
#  owner_id                  :uuid             not null
#  default_currency_iso_code :string
#
class Book < ApplicationRecord
  include Currencyable

  belongs_to :owner, class_name: "User"

  has_currency :default_currency

  has_many :book_rights, dependent: :destroy
  has_many :registers, dependent: :destroy

  validates :name, presence: true
  validates :owner, presence: true
end
