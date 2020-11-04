# frozen_string_literal: true

# == Schema Information
#
# Table name: book_roles
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  book_id    :uuid             not null
#  user_id    :uuid             not null
#  role       :string           not null
#
FactoryBot.define do
  factory :book_role do
    book_id { Book.ids.sample }
    user_id { User.ids.sample }
    role { "reader" }
  end
end
