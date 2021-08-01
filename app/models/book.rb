# frozen_string_literal: true

# == Schema Information
#
# Table name: books
#
#  id                        :bigint           not null, primary key
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  name                      :string           not null
#  owner_id                  :bigint           not null, indexed
#  default_currency_iso_code :string(3)        not null
#
class Book < ApplicationRecord
  include Currencyable
  include Importable

  belongs_to :owner, class_name: "User"

  has_many :book_roles, dependent: :destroy
  # To get root register: book.registers.root
  has_many :registers, dependent: :destroy
  has_many :exchanges, through: :registers
  has_many :reminders, dependent: :destroy

  has_currency :default_currency

  # rubocop:disable Metrics/AbcSize
  def debug_registers_tree
    registers_per_parent_id = registers.group_by(&:parent_id)
    exchange_count_per_register_id = Exchange.group(:register_id).count
    split_count_per_register_id = Split.group(:register_id).count

    logger.info "Book '#{name}'"
    output_register = ->(level:, parent_id:) do
      registers_per_parent_id[parent_id]&.each do |r|
        logger.info [
          "#{'|   ' * (level - 1)}|- #{r.type} '#{r.name}' (#{r.currency_iso_code})#{' ⛔️' unless r.active}",
          "#{exchange_count_per_register_id.fetch(r.id, 0) + split_count_per_register_id.fetch(r.id, 0)} exchanges (#{exchange_count_per_register_id.fetch(r.id, 0)} + #{split_count_per_register_id.fetch(r.id, 0)})",
        ].join(" // ")
        output_register.call(level: level + 1, parent_id: r.id)
      end
    end
    output_register.call(level: 1, parent_id: nil)

    nil
  end
  # rubocop:enable Metrics/AbcSize
end
