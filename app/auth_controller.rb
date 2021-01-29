# frozen_string_literal: true

require_relative 'application_controller'

module App
  class AuthController < ApplicationController
    get '/' do
      authorize(current_user)
      200
    end

    post '/' do
      user = User.find_by(email: params[:user][:email])
      authorize(check_password(user, params[:user][:password]))

      save_user_id_to_session(user.id)
      200
    end

    delete '/' do
      save_user_id_to_session(nil)
      200
    end

    private

    def check_password(user, password)
      user.present? && BCrypt::Password.new(user.password) == password
    end
  end
end
