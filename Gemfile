# frozen_string_literal: true

source 'https://rubygems.org'

gem 'bcrypt'
gem 'json'
gem 'logger'
gem 'pg'
gem 'rake'
gem 'redis'
gem 'require_all'
gem 'securerandom'
gem 'sinatra'
gem 'sinatra-activerecord'
gem 'yaml'

group :development do
  gem 'rubocop'
  gem 'sinatra-contrib', require: false
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
