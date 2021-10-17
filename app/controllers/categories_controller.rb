# frozen_string_literal: true

class CategoriesController < ApplicationController
  # @route GET /books/:book_id/categories (book_categories)
  def index
    @categories_per_parent = @book.registers.categories.order(:name).group_by(&:parent_id)
  end

  # @route GET /books/:book_id/categories/:id (book_category)
  def show
  end
end
