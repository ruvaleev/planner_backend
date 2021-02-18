# frozen_string_literal: true

ENV['SINATRA_ENV'] ||= 'development'

require_relative 'config/environment'
require 'rollbar/rake_tasks'
require 'sinatra/activerecord/rake'

task :environment do
  require_relative 'config/initializers/rollbar'
end
