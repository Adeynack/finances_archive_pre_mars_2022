# frozen_string_literal: true

class BookRoleDefinition
  include ActiveModel::Model

  attr_accessor :name
  attr_accessor :description
  attr_accessor :effective_roles

  class << self
    def all
      all_indexed.values
    end

    def find_by!(name:)
      all_indexed[name.to_sym] || raise(ActiveRecord::RecordNotFound, "Cannot find a role definition with name #{name}")
    end

    def names
      all_indexed.keys
    end

    private

    def generate_source_definition
      {
        owner: {
          description: "Can access, modify, administrate and change ownership of the book.",
          all_of: :admin
        },
        admin: {
          description: "Can access, modify, and administrate the book.",
          all_of: [:reader, :writer]
        },
        writer: {
          description: "Can access, and modify the book.",
          all_of: :reader
        },
        reader: {
          description: "Can access the book only to read it."
        }
      }
    end

    def all_indexed
      @all_indexed ||= begin
        source_definition = generate_source_definition
        resolve_effective_roles = ->(role) do
          role_attr = source_definition.fetch(role)
          role_attr[:effective_roles] ||= Array.wrap(role_attr[:all_of])
            .flat_map { |all_of| resolve_effective_roles.call(all_of) }
            .push(role)
            .uniq
            .freeze
        end
        source_definition.map do |name, attributes|
          record = BookRoleDefinition.new(
            name: name.to_s,
            description: attributes[:description],
            effective_roles: resolve_effective_roles.call(name).map(&:to_s)
          )
          [name, record]
        end.to_h
      end
    end
  end
end
