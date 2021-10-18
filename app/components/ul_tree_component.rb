# frozen_string_literal: true

class UlTreeComponent < ViewComponent::Base
  def initialize(items, children_extractor, &block)
    super
    @items = items
    @item_renderer = block
    @children_extractor =
      case children_extractor
      when Proc then children_extractor
      when Symbol then ->(parent_item) { parent_item.send(children_extractor) }
      else raise ArgumentError, "invalid children_extractor"
      end
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

  private

  def render_item(item)
    @item_renderer.call(item)
  end

  def extract_children(item)
    @children_extractor.call(item)
  end
end
