# frozen_string_literal: true

# == Schema Information
#
# Table name: splits
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  transaction_id     :bigint           not null, indexed
#  register_id        :bigint           not null, indexed
#  amount             :integer          not null
#  counterpart_amount :integer
#  memo               :text
#  status             :enum             default("uncleared"), not null
#
class Split < ApplicationRecord
  belongs_to :txn, class_name: "Transaction", foreign_key: "transaction_id", inverse_of: :splits # `transaction` is an ActiveRecord method and cannot be used for relation name.
  belongs_to :register # destinations of the transaction's split
end
