# frozen_string_literal: true

module HeaderBarHelper
  def nav_item_link_to(text, path)
    content_tag "li", class: "nav-item" do
      link_to_unless_current text, path, class: "nav-link" do
        content_tag "span", text, class: "nav-link active", "aria-current": "page"
      end
    end
  end

  def dropdown_menu_link_to(text, path)
    content_tag "li" do
      link_to_unless_current text, path, class: "dropdown-item" do
        content_tag "span", text, class: "dropdown-item"
      end
    end
  end
end
