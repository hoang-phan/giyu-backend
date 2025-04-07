source "https://rubygems.org"

gem "rails", "~> 8.0.1"
gem "aasm"
gem "propshaft"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails", "~> 3"
gem "tailwindcss-ruby", "~> 3"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "active_model_serializers"
gem "cocoon"
gem "haml-rails"

gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false
gem "activeadmin", "4.0.0beta15"
gem "devise"
gem "cancancan"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "shoulda-matchers"
  gem "simplecov"
  
  # System testing
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end

group :development do
  gem "web-console"
end
