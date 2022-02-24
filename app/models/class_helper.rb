# frozen_string_literal: true

module ClassHelper
  def find_descendant_from_files(parent_class, path: "app/models/**/.rb")
    all_files = Dir[Rails.root.join(path)]
    all_files.map! { |path| File.basename(path, ".rb").classify.constantize }
    all_files.filter! { |c| c.ancestors[1..].include?(parent_class) }
    all_files
  end
end
