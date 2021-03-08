# frozen_string_literal: true

# == Schema Information
#
# Table name: bank_accounts
#
#  id             :uuid             not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  bank_name      :string
#  account_number :string
#
class BankAccount < ApplicationRecord
  include Registerable
end
