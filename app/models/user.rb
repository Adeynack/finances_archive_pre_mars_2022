# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           not null
#  encrypted_password     :string           not null
#  display_name           :string           not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#
class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :registerable, :validatable # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
end
