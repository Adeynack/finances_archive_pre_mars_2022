# frozen_string_literal: true

require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FinancesRails
  class Application < Rails::Application
    config.load_defaults 6.0

    I18n.default_locale = :en
    config.time_zone = "Europe/Berlin"

    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore, key: "_flink", expire_after: 14.days

    config.autoload_paths += Dir[Rails.root.join("app", "graphql", "loaders", "**/")]
    config.autoload_paths += Dir[Rails.root.join("app", "refinements", "**/")]
  end
end
