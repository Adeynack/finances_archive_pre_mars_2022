# frozen_string_literal: true

# == Schema Information
#
# Table name: registers
#
#  id                :uuid             not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  book_id           :uuid             not null
#  parent_id         :uuid
#  name              :string           not null
#  type              :string           not null
#  info              :jsonb
#  notes             :text
#  currency_iso_code :string
#  initial_balance   :integer          default(0), not null
#  active            :boolean          default(TRUE), not null
#
class Register < ApplicationRecord
  include Currencyable

  belongs_to :book
  belongs_to :parent, class_name: "Register", optional: true

  has_many :child, class_name: "Register", dependent: :destroy, foreign_key: "parent_id", inverse_of: "parent"

  has_currency :currency, optional: true

  validates :name, presence: true
  validate :validate_parent_not_itself

  class << self
    def list_register_classes(type)
      Dir[Rails.root.join("app/models/#{type.parameterize}/*.rb")].map do |f|
        class_name = f.split("/").last.delete_suffix(".rb").classify
        klass = [type, class_name].join("::").constantize
        [class_name, klass]
      end.to_h
    end

    # def sti_name
    #   @sti_name ||= name.delete_prefix("Register::")
    # end

    # def find_sti_class(type_name)
    #   KNOWN_TYPES.fetch(type_name)
    # end

    # # Hash: STI Name => Model Class
    # KNOWN_TYPES = begin
    #   mapping = {}
    #   known_types = [Register::Category::KNOWN_TYPES, Account::KNOWN_TYPES].entries.flatten
    #   known_types.each do |name, klass|
    #     type_already_using_name = mapping.key?(name)
    #     raise StandardError, "duplicate STI name '#{name}' for '#{type_already_using_name.name}' and '#{register_type.name}'" if type_already_using_name.present?

    #     mapping[name] = klass
    #   end
    #   mapping.freeze
    # end
  end

  def validate_parent_not_itself
    errors.add :parent, "cannot be itself" if parent_id.present? && parent_id == id
  end
end
