# frozen_string_literal: true

# == Schema Information
#
# Table name: transactions
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  date        :date             not null, indexed
#  register_id :bigint           not null, indexed
#  cheque      :string
#  description :string           not null
#  memo        :text
#  status      :enum             default(NULL), not null
#
class Transaction < ApplicationRecord
  belongs_to :register # origin of the transaction

  has_many :splits, dependent: :destroy

  enum status: [:uncleared, :reconciling, :cleared].index_with(:to_s)

  validates :description, presence: true
  validates :date, presence: true
end
