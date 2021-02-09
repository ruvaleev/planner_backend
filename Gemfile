# frozen_string_literal: true

source 'https://rubygems.org'

gem 'activerecord', '< 6.1.0'
gem 'bcrypt'
gem 'json'
gem 'logger'
gem 'pg'
gem 'rake'
gem 'require_all'
gem 'securerandom'
gem 'sidekiq'
gem 'sidekiq-scheduler'
gem 'sinatra'
gem 'sinatra-activerecord'
gem 'yaml'

group :development do
  gem 'database_consistency', require: false
  gem 'rubocop'
  gem 'sinatra-contrib', require: false
  gem 'strong_migrations'
end

group :development, :test do
  gem 'byebug'
end

group :test do
  gem 'database_cleaner-active_record'
  gem 'factory_bot'
  gem 'ffaker'
  gem 'rack-test'
  gem 'rspec'
  gem 'shoulda-matchers', '~> 4.0'
end
