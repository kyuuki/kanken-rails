require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module KankenRails
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # i18n
    # https://railsguides.jp/i18n.html
    config.i18n.default_locale = :ja
    config.time_zone = "Tokyo"

    config.host = "rails-dev.akoba.xyz"
    config.port = 3000
    config.url = "http://#{config.host}:#{config.port}"
    config.blog_url = "https://blog.kanken-j1.fkoba.com"
  end
end
