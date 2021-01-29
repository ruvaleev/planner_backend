# frozen_string_literal: true

require_relative 'application_controller'

module App
  class UsersController < ApplicationController
    post '/' do
      user = User.create(params[:user])

      if user.persisted?
        save_user_id_to_session(user.id)
        200
      else
        return_errors(user.errors.messages)
      end
    end
  end
end
