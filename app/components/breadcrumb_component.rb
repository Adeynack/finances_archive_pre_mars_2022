# frozen_string_literal: true

class BreadcrumbComponent < ViewComponent::Base
  def initialize(*steps)
    super
    ap steps
    @steps = steps.filter_map { |step| transform_step(step) }
    ap @steps
  end

  private

  def transform_step(step)
    case step
    when Book then transform_book(step)
    else step
    end
  end

  def transform_book(book)
    { label: book.name, to: book }
  end
end
