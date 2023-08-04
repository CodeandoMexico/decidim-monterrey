# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION
DECIDIM_VERSION = "0.26.3"

gem "dotenv-rails", groups: [:development, :test, :production]

gem "decidim", DECIDIM_VERSION
gem "decidim-ine", path: "decidim-module-ine"
gem "omniauth-idmty", path: "omniauth-idmty"

gem "bootsnap", "~> 1.3"
gem "puma", ">= 5.0.0"
gem "faker", "~> 2.14"
gem "wicked_pdf", "~> 2.1"
gem "clockwork"
gem "delayed_job_active_record"
gem "daemons"
gem "decidim-friendly_signup"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri
  gem "decidim-dev", DECIDIM_VERSION
  gem "pry"
  gem "standard"
  gem "rspec-rails"
end

group :development do
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 4.0"
  gem "ripper-tags"
  gem "figaro"
end
