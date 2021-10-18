# frozen_string_literal: true

class BreadcrumbComponent < ViewComponent::Base
  def initialize(title_to_path_hash)
    super
    @title_to_path_hash = title_to_path_hash
  end
end
