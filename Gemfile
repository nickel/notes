# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.2.3"

gem "rails", "~> 7.1.3"

gem "bootsnap", require: false
gem "importmap-rails"
gem "jbuilder"
gem "packwerk"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i(windows jruby)

gem "coderay"
gem "redcarpet"

group :development, :test do
  gem "debug", platforms: %i(mri windows)
end

group :development do
  gem "brakeman"
  gem "bundler-audit"
  gem "foreman"
  gem "rubocop"
  gem "spring"
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
