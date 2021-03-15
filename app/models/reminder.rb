# frozen_string_literal: true

# == Schema Information
#
# Table name: reminders
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  book_id        :bigint           not null, indexed
#  title          :string           not null
#  description    :text
#  mode           :enum             default("manual"), not null
#  during         :tsrange          not null
#  recurrence     :string
#  last_commit_at :string
#  transaction_id :bigint           not null, indexed
#
class Reminder < ApplicationRecord
  belongs_to :book
  belongs_to :tnx, class_name: "Transaction", foreign_key: "transaction_id", dependent: :destroy, inverse_of: false

  enum mode: [:manual, :auto_commit, :auto_cancel].index_with(&:to_s)

  validates :title, presence: true
  validate :validate_reminder_register

  before_validation do
    if tnx.present?
      reminder_register_id = book.ensure_reminder_register_id!
      tnx.register_id ||= reminder_register_id
    end
  end

  private

  def validate_reminder_register
    errors.add(:transaction, "transaction's register has to be the book's reminder_register") unless transaction_id.nil? || tnx.register.book_id == book_id # TODO: i18n message
  end
end
