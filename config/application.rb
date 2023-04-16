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

    # 設定ファイル
    # https://railsguides.jp/configuring.html#%E3%82%AB%E3%82%B9%E3%82%BF%E3%83%A0%E8%A8%AD%E5%AE%9A
    config.setting = config_for(:setting)

    # i18n
    # https://railsguides.jp/i18n.html
    config.i18n.default_locale = :ja
    config.time_zone = "Tokyo"
  end
end
