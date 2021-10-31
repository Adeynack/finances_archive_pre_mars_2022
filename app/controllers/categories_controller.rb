# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  # @route GET /books/:book_id/categories (book_categories)
  def index
    @categories = @book.categories
  end

  # @route GET /books/:book_id/categories/:id (book_category)
  def show
  end

  # @route GET /books/:book_id/categories/:id/edit (edit_book_category)
  def edit
  end

  # @route PATCH /books/:book_id/categories/:id (book_category)
  # @route PUT /books/:book_id/categories/:id (book_category)
  def update
  end

  # @route DELETE /books/:book_id/categories/:id (book_category)
  def destroy
  end

  private

  def set_category
    @category = @book.registers.categories.find(params[:id])
  end
end
