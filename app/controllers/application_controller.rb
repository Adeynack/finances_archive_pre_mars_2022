# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_book_and_breadcrumbs

  protected

  Crumb = Struct.new(:name, :target, :title, keyword_init: true)

  def breadcrumbs
    raise NotImplementedError, "Controllers need to implement `breadcrumbs`. If none, make it return an empty array."
  end

  def set_book(book_id: params[:book_id]) # rubocop:disable Naming/AccessorMethodName
    @book = book_id&.then { |id| current_user.all_accessible_books.find(id) }
  end

  def book_crumb
    Crumb.new(name: @book.name, target: @book) if @book
  end

  private

  def set_book_and_breadcrumbs
    set_book
    @breadcrumbs = breadcrumbs
  end
end
