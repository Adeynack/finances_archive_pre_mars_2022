# frozen_string_literal: true

class BreadcrumbComponent < ViewComponent::Base
  def initialize(*steps)
    super
    @steps = steps.filter_map { |step| transform_step(step) }
  end

  private

  def transform_step(step)
    case step
    when Book then transform_book(step)
    else step
    end
  end

  def transform_book(book)
    {
      label: book.name,
      to: book,
      title: book&.then { |b| "The current book is \"#{b.name}\", owned by #{b.owner.display_name} (#{b.owner.email})" }
    }
  end
end
