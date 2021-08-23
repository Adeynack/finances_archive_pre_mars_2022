# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  # @route GET /books (books)
  def index
    @books = Book.all
  end

  # @route GET /books/:id (book)
  def show
  end

  # @route GET /books/new (new_book)
  def new
    @book = Book.new
  end

  # @route GET /books/:id/edit (edit_book)
  def edit
  end

  # @route POST /books (books)
  def create
    @book = Book.new(book_params)

    if @book.save
      redirect_to @book, notice: "Book was successfully created."
    else
      render :new
    end
  end

  # @route PATCH /books/:id (book)
  # @route PUT /books/:id (book)
  def update
    if @book.update(book_params)
      redirect_to @book, notice: "Book was successfully updated."
    else
      render :edit
    end
  end

  # @route DELETE /books/:id (book)
  def destroy
    @book.destroy
    redirect_to books_url, notice: "Book was successfully destroyed."
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.fetch(:book, {})
  end
end
