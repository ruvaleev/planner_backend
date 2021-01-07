# frozen_string_literal: true

require_relative 'application_controller'

module App
  class AuthController < ApplicationController
    get '/' do
      user_id = $redis.get(params[:token])
      user = User.find_by(id: user_id)
      clear_old_token(params[:token])

      user.present? ? return_auth_token(user_id) : return_unauthorized
    end

    post '/' do
      user = User.find_by(email: params[:user][:email])
      authorized = check_password(user, params[:user][:password])

      authorized ? return_auth_token(user.id) : return_unauthorized
    end

    delete '/' do
      clear_old_token(params[:token])

      200
    end

    private

    def check_password(user, password)
      user.present? && BCrypt::Password.new(user.password) == password
    end

    def clear_old_token(old_token)
      $redis.del(old_token)
    end

    def issue_new_token(user_id)
      new_token = SecureRandom.hex(32)
      $redis.set(new_token, user_id, ex: ENV['REDIS_TIMEOUT'])
      new_token
    end

    def return_auth_token(user_id)
      [200, { auth_token: issue_new_token(user_id) }.to_json]
    end

    def return_unauthorized
      [401, { errors: ['Unauthorized'] }.to_json]
    end
  end
end
