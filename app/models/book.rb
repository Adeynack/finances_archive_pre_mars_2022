# frozen_string_literal: true

# == Schema Information
#
# Table name: books
#
#  id                  :uuid             not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  name                :string           not null
#  owner_id            :uuid             not null
#  default_currency_id :uuid             not null
#
class Book < ApplicationRecord
  belongs_to :owner, class_name: "User"
  belongs_to :default_currency, class_name: "Currency", inverse_of: :books

  has_many :book_rights, dependent: :destroy
  has_many :registers, dependent: :destroy

  validates :name, presence: true
  validates :owner, presence: true
end
