# frozen_string_literal: true

# == Schema Information
#
# Table name: book_roles
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  book_id    :bigint           not null, indexed, indexed => [user_id, role]
#  user_id    :bigint           not null, indexed => [book_id, role], indexed
#  role       :enum             not null, indexed => [book_id, user_id]
#
require "test_helper"

class BookRoleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
