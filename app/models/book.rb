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

  belongs_to :owner, class_name: "User", inverse_of: :books

  has_currency :default_currency

  has_many :book_roles, dependent: :destroy
  has_many :registers, dependent: :destroy

  validates :name, presence: true
  validates :owner, presence: true

  after_commit :ensure_owner_has_owner_role, on: :update

  private

  def ensure_owner_has_owner_role
    owner_right = book_roles.find_or_initialize_by(user: owner)
    owner_right.access = "owner"
    owner_right.save!
  end
end
