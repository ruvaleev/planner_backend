# frozen_string_literal: true

require './config/environment'

run Rack::URLMap.new(
  '/areas' => App::AreasController,
  '/auth' => App::AuthController,
  '/users' => App::UsersController
)
