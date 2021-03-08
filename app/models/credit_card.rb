# frozen_string_literal: true

# == Schema Information
#
# Table name: credit_cards
#
#  id          :uuid             not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  card_number :string
#  expires_at  :datetime
#  limit       :integer
#
class CreditCard < ApplicationRecord
  include Registerable
end
