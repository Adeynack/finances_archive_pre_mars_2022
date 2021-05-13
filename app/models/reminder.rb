# frozen_string_literal: true

# == Schema Information
#
# Table name: reminders
#
#  id                      :bigint           not null, primary key
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  book_id                 :bigint           not null, indexed
#  title                   :string           not null
#  description             :text
#  mode                    :enum             default("manual"), not null
#  first_date              :date             not null
#  last_date               :date
#  recurrence              :string
#  last_commit_at          :string
#  transaction_register_id :bigint           not null, indexed
#  transaction_description :string           not null
#  transaction_memo        :text
#  transaction_status      :enum             default("uncleared"), not null
#
class Reminder < ApplicationRecord
  belongs_to :book
  belongs_to :transaction_register, class_name: "Register"

  has_many :reminder_splits, dependent: :destroy

  enum mode: [:manual, :auto_commit, :auto_cancel].index_with(&:to_s)

  validates :title, presence: true
  validates :first_date, presence: true
  validate :validate_last_date_after_first_date
  validates :transaction_register, presence: true
  validate :validate_transaction_register_on_same_book_as_reminder
  validates :transaction_description, presence: true

  before_validation do
    self.first_date = Time.zone.today if first_date.blank?
  end

  private

  def validate_last_date_after_first_date
    errors.add :last_date, "must be after first date" if last_date.present? && first_date >= last_date
  end

  def validate_transaction_register_on_same_book_as_reminder
    errors.add :transaction_register, "must belong to the same book as the reminder" if transaction_register.book_id != book_id
  end
end
