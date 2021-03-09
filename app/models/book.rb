# frozen_string_literal: true

# == Schema Information
#
# Table name: books
#
#  id                        :bigint           not null, primary key
#  created_at                :datetime         not null
#  name                      :string           not null
#  default_currency_iso_code :string(3)        not null
#
class Book < ApplicationRecord
  belongs_to :owner, class_name: "User"
end
