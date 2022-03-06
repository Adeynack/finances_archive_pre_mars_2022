# frozen_string_literal: true

class OptionBarComponent < ViewComponent::Base
  def initialize(*options)
    super
    @options = options
  end
end
