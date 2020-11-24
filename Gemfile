source "https://rubygems.org"
git_source(:github){|repo| "https://github.com/#{repo}.git"}

ruby "2.7.1"

gem "activerecord-import"
gem "bootsnap", ">= 1.4.2", require: false
gem "bootstrap", "~> 4.0.0"
gem "cancancan"
gem "carrierwave", "~> 2.0"
gem "config"
gem "devise"
gem "factory_bot_rails"
gem "figaro"
gem "font-awesome-sass", "~> 5.13.0"
gem "grape"
gem "grape-entity"
gem "grape_on_rails_routes"
gem "jbuilder", "~> 2.7"
gem "jwt"
gem "mysql2"
gem "omniauth-google-oauth2"
gem "puma", "~> 4.1"
gem "rails", "~> 6.0.3", ">= 6.0.3.3"
gem "rails-i18n"
gem "ransack"
gem "sass-rails", ">= 6"
gem "sidekiq"
gem "turbolinks", "~> 5"
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem "validates_timeliness"
gem "webpacker", "~> 4.0"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "pry-byebug"
  gem "rails_best_practices"
  gem "rspec-rails", "~> 4.0.1"
  gem "rubocop", "~> 0.74.0", require: false
  gem "rubocop-checkstyle_formatter", require: false
  gem "rubocop-rails", "~> 2.3.2", require: false
end

group :development do
  gem "listen", "~> 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "database_cleaner-active_record"
  gem "execjs"
  gem "faker"
  gem "rails-controller-testing"
  gem "selenium-webdriver"
  gem "shoulda-callback-matchers"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "simplecov-rcov"
  gem "therubyracer"
  gem "webdrivers"
end
