# frozen_string_literal: true

require './config/environment'

run Rack::URLMap.new(
  '/auth' => App::AuthController,
  '/users' => App::UsersController
)
