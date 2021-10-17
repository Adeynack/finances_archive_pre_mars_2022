# frozen_string_literal: true

class TreeViewComponent < ViewComponent::Base
  def initialize(items, item_renderer, children_extractor)
    super
    @items = items
    @item_renderer = item_renderer
    @children_extractor = children_extractor
  end

  def render_item(item)
    case @item_renderer
    when Proc then @item_renderer.call(item)
    when Symbol then item.send(@item_renderer)
    else raise ArgumentError, "invalid item_renderer"
    end
  end

  def extract_children(item)
    case @children_extractor
    when Proc then @children_extractor.call(item)
    when Symbol then item.send(@children_extractor)
    else raise ArgumentError, "invalid children_extractor"
    end
  end
end
