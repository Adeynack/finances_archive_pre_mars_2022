# frozen_string_literal: true

source "https://rubygems.org"
ruby "2.7.2"

# Core
gem "rails", "~> 6.0.3"
gem "puma"

# Database
gem "pg"
gem "redis"

# Extensions
gem "bootsnap", require: false
gem "dotenv-rails"
gem "rails-i18n"
gem "oj"
gem "kaminari"
gem "friendly_id"
gem "pundit"
gem "active_record_extended"
gem "bcrypt"
gem "store_model"

# Jobs
gem "sidekiq"
gem "sidekiq-scheduler"

# GraphQL
gem "graphql"
gem "graphql-rails_logger"
gem "graphql-persisted_queries"
gem "graphql-batch"
gem "graphiql-rails"

# Seed Data
gem "factory_bot_rails"
gem "faker"

# Debugging
gem "pry-rails"
gem "awesome_print"

# Geography & Money
gem "countries"
gem "money", "~> 6.13.7"
gem "money-rails", "~> 1.13.3"

group :development, :test do
  gem "rspec-rails"

  gem "rubocop"
  gem "rubocop-rails"
  gem "rubocop-rspec"
  gem "rubocop-rspec-focused"
  gem "rubocop-faker"
  gem "rubocop-performance"

  gem "guard"
  gem "guard-rspec", require: false

  gem "byebug"
  gem "pry-doc"
  gem "pry-stack_explorer"

  gem "bullet"
  gem "spring"
  gem "spring-watcher-listen"
  gem "spring-commands-rspec"
  gem "oink"
end

group :test do
  gem "simplecov", require: false
  gem "simplecov-json", require: false
  gem "fuubar"
  gem "n_plus_one_control"
end

group :development do
  gem "web-console"
  gem "listen"
  gem "annotate"
  gem "erd"
end
