# frozen_string_literal: true

class HeaderBarComponent < ViewComponent::Base
  def initialize(current_user:)
    super
    @current_user = current_user
  end
end
