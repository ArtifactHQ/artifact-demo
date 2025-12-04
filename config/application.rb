require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Template
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Allow embedding in iframe from marketing site
    # In development: Allow all origins for easy local testing
    # In production: Restrict to artifact.new only
    if Rails.env.development?
      config.action_dispatch.default_headers = {
        'X-Frame-Options' => nil  # Allow all origins in development
      }
    else
      config.action_dispatch.default_headers = {
        'X-Frame-Options' => nil,
        'Content-Security-Policy' => "frame-ancestors 'self' https://artifact.new http://artifact.new"
      }
    end

    # Disable CSRF for demo purposes (no sensitive data submission)
    config.action_controller.default_protect_from_forgery = false
  end
end
