# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_book

  private

  def set_book
    @book = params[:book_id]&.then { |id| current_user.all_accessible_books.find(id) }
  end
end
