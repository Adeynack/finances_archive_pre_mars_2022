# frozen_string_literal: true

class CreateAccountTypes < ActiveRecord::Migration[6.0]
  # Following instruction on enums from https://naturaily.com/blog/ruby-on-rails-enum
  def up
    execute <<~SQL
      CREATE TYPE account_type AS ENUM(
        -- categories
        'Expense',
        'Income',
        -- accounts
        'Other',
        'Bank',
        'Card',
        'Investment',
        'Asset',
        'Liability',
        'Loan',
        -- special
        'Group'
      );
    SQL
  end

  def down
    execute <<~SQL
      DROP TYPE account_type;
    SQL
  end
end
