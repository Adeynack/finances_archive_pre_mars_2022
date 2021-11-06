# frozen_string_literal: true

class AccountsController < ApplicationController
  # @route GET /books/:book_id/accounts (book_accounts)
  def index
    @accounts_per_parent = @book.registers.accounts.order(:name).group_by(&:parent_id)
  end

  protected

  def breadcrumbs
    [
      book_crumb,
      Crumb.new(name: "Accounts", target: book_accounts_path(@book)),
    ]
  end
end
