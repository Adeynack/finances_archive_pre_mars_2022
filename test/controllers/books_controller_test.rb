# frozen_string_literal: true

# == Schema Information
#
# Table name: books
#
#  id                        :bigint           not null, primary key
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  name                      :string           not null
#  owner_id                  :bigint           not null, indexed
#  default_currency_iso_code :string(3)        not null
#
require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book = books(:joe)
  end

  # test "should get index" do
  #   get books_url
  #   assert_response :success
  # end

  # test "should get new" do
  #   get new_book_url
  #   assert_response :success
  # end

  # test "should create book" do
  #   assert_difference("Book.count") do
  #     post books_url, params: { book: {} }
  #   end

  #   assert_redirected_to book_url(Book.last)
  # end

  # test "should show book" do
  #   get book_url(@book)
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get edit_book_url(@book)
  #   assert_response :success
  # end

  # test "should update book" do
  #   patch book_url(@book), params: { book: {} }
  #   assert_redirected_to book_url(@book)
  # end

  # test "should destroy book" do
  #   assert_difference("Book.count", -1) do
  #     delete book_url(@book)
  #   end

  #   assert_redirected_to books_url
  # end
end
