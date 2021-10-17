# frozen_string_literal: true

class HeaderBarComponent < ViewComponent::Base
  def initialize(current_user:, current_book:)
    super
    @current_user = current_user
    @current_book = current_book
  end
end
