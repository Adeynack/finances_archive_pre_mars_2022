# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  # @route GET /books/:book_id/categories (book_categories)
  def index
    @categories_per_parent = @book.registers.categories.order(:name).group_by(&:parent_id)
  end

  # @route GET /books/:book_id/categories/:id (book_category)
  def show
  end

  private

  def set_category
    @category = @book.registers.categories.find(params[:id])
  end
end
