# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :set_account, only: [:show]

  # @route GET /books/:book_id/accounts (book_accounts)
  def index
    @accounts_per_parent = @book.accounts.order(:name).group_by(&:parent_id)
  end

  # @route GET /books/:book_id/accounts/:id (book_account)
  def show
  end

  private

  def set_account
    @account = @book.accounts.find(params[:id])
  end
end
