# frozen_string_literal: true

require_relative 'application_controller'

module App
  class UsersController < ApplicationController
    post '/' do
      user = User.create(params[:user])

      user.persisted? ? [200, { user: user.email }.to_json] : [403, { errors: user.errors.messages }.to_json]
    end
  end
end
