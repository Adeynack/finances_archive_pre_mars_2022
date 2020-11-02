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
class BookRole < ApplicationRecord
  belongs_to :book
  belongs_to :user

  enum_sym right: BookRoleDefinition.names

  def effective_roles
    BookRoleDefinition.find_by!(name: role).effective_roles
  end
end
