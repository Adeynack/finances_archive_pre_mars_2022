# frozen_string_literal: true

# A basic concept of hierarchy between elements of the same model (or table).
#
# TODO: Research for existing solutions to this.
# TODO: How could we preload those? Making them associations?
#
module Hierarchical
  extend ActiveSupport::Concern

  class_methods do
    def parent_chain_by(parent_id_column:, child_id:)
      find_by_sql <<~SQL.squish
        with recursive rec as (
          select *
          from #{table_name}
          where id = #{child_id}

          union all

          select registers.*
          from registers
          join rec on rec.#{parent_id_column} = #{table_name}.#{primary_key}
        )
        select *
        from rec
      SQL
    end

    # rubocop:disable Naming:PredicateName
    def is_hierarchical(from:, to:, dependent: :destroy)
      raise StandardError, "parent column already defined" unless @hierarchy_from_relation.nil?

      @hierarchical_relations ||= {}
      raise StandardError, "A hierarchical relation from '#{from}' is already defined." if @hierarchical_relations.key?(from)

      belongs_to from, class_name: name.to_s, optional: true, inverse_of: to
      has_many to, class_name: name.to_s, foreign_key: "#{from}_id", inverse_of: from, dependent: dependent

      parent_id_column = reflect_on_association(from).foreign_key
      @hierarchical_relations[from] = {
        to: to,
        parent_id_column: parent_id_column
      }

      define_method "#{from}_chain" do
        self.class.parent_chain_by(parent_id_column: parent_id_column, child_id: id)
      end
    end
    # rubocop:enable Naming:PredicateName
  end
end
