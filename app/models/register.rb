# frozen_string_literal: true

# == Schema Information
#
# Table name: registers
#
#  id                :uuid             not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  book_id           :uuid             not null
#  name              :string
#  initial_balance   :integer
#  registerable_type :string
#  registerable_id   :uuid
#
class Register < ApplicationRecord
  belongs_to :book
  delegated_type :registerable, types: ["bank_account", "credit_card"], dependent: :destroy
  # delegated_type :registerable, types: ["bank_account", "credit_card", "placeholder"], dependent: :destroy
end
