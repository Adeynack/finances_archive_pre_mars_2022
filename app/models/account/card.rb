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
class Account::Card < Account
end
