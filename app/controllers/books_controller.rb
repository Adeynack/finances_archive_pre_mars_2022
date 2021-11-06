# frozen_string_literal: true

class BooksController < ApplicationController
  # @route GET / (root)
  # @route GET /books (books)
  def index
    @books = current_user.all_accessible_books.order(:name).includes(:owner)
  end

  # @route GET /books/:id (book)
  def show
    current_user.update! last_book: @book
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

  protected

  def set_book
    super(book_id: params[:id]) unless [:index, :create].include?(params[:action])
  end

  def breadcrumbs
    [book_crumb]
  end

  private

  def book_params
    params.fetch(:book, {})
  end
end
