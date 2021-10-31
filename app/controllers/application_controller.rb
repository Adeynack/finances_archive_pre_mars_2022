# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_book

  private

  def set_book
    @book = Book.find(params[:book_id]) if params.key?(:book_id)
  end
end
