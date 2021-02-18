# frozen_string_literal: true

ENV['SINATRA_ENV'] ||= 'development'

require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])

config = YAML.load_file('secrets.yml')[ENV['SINATRA_ENV']] if File.file?('secrets.yml')

config&.each { |name, value| ENV[name] ||= value }
ActiveRecord::Base.establish_connection(ENV['DATABASE_URL']) if ENV['DATABASE_URL']

require_all 'app'
require_all 'config/initializers'
require_all 'models'
require_all 'services'
require_all 'workers'
