require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TimesheetProject
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.api_only = true

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'  # Update this with appropriate origins
        resource '*', headers: :any, methods: [:get, :post, :put, :patch, :delete, :options]
      end
    end

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    
    # Includes the root when using "as_json". For example, when returning a user, it will look like:
    #
    # "user": {
    #   "first_name": "example"
    # }
    #
    # instead of 
    #
    # { 
    # "first_name": "example" 
    # }
    # 
    # which means that our expected output will match our expected input. Nice and clean, right?

    config.active_record.include_root_in_json = true
  end
end
