# frozen_string_literal: true

Rollbar.configure do |config|
  config.access_token = ENV['ROLLBAR_SERVER_ITEM_ACCESS_TOKEN']
  config.environment = ENV['SINATRA_ENV']
  config.locals = { enabled: true }
end
