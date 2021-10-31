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

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def set_category
    @category = @book.registers.categories.find(params[:id])
  end
end
