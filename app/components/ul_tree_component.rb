# frozen_string_literal: true

class UlTreeComponent < ViewComponent::Base
  def initialize(items, children_extractor, &block)
    super
    @items = items
    @item_renderer = block
    @children_extractor = children_extractor
  end

  class << self
    def by_parent_id(items_hashed_by_parent_id, &block)
      UlTreeComponent.new(
        items_hashed_by_parent_id[nil],
        ->(item) { items_hashed_by_parent_id[item.id] },
        &block
      )
    end
  end

  def render_item(item)
    @item_renderer.call(item)
  end

  def extract_children(item)
    case @children_extractor
    when Proc then @children_extractor.call(item)
    when Symbol then item.send(@children_extractor)
    else raise ArgumentError, "invalid children_extractor"
    end
  end
end
