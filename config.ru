# frozen_string_literal: true

require './config/environment'

run Rack::URLMap.new(
  '/areas' => App::AreasController,
  '/auth' => App::AuthController,
  '/todos' => App::TodosController,
  '/users' => App::UsersController
)
