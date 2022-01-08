# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(".ruby-version").strip.split("-").last # <--> .github/workflows/tests.yml

# Core
gem "rails", "~> 7.0.1"
gem "puma", "~> 5.0"
gem "sprockets-rails"

# Database
gem "pg", "~> 1.1"
gem "redis", "~> 4.0"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Model & ORM
gem "active_record_union"
# gem "active_record_extended"
gem "friendly_id"
gem "closure_tree"

# Auth & Administration
gem "devise"
gem "pundit"

# Extensions
gem "slim"
gem "slim-rails"
gem "rails-i18n"
gem "awesome_print"
gem "kaminari"
gem "dotenv-rails"
gem "view_component" # , require: "view_component/engine"

# Jobs
gem "sidekiq"
gem "sidekiq-scheduler"

# Geography & Money & Data Modelling
gem "countries"
gem "money", "~> 6.13.7"
gem "money-rails", "~> 1.13.3"
gem "iban-tools"
gem "montrose" # , git: "https://github.com/rossta/montrose.git"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "pry-rails"
  gem "pry-byebug"
  gem "pry-doc" # ruby/3.0.0 isn't supported by this pry-doc version
  gem "pry-rescue"
  gem "pry-stack_explorer"
  gem "standard"
  gem "rubocop", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-performance", require: false
  gem "annotate", github: "dabit/annotate_models", branch: "rails-7"
  gem "chusaku", require: false
  gem "i18n-tasks"
  # gem "ruby_jard", git: "https://github.com/nguyenquangminh0711/ruby_jard"
  gem "bullet"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  gem "guard"
  gem "guard-minitest"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "minitest-focus"
end
