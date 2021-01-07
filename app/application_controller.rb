# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/reloader' if development?

module App
  class ApplicationController < Sinatra::Base
    configure do
      enable :sessions
    end
    configure :production, :development do
      enable :logging
    end
    configure :development do
      register Sinatra::Reloader
    end

    before do
      response.headers['Access-Control-Allow-Origin'] = '*'
      if request.request_method == 'OPTIONS'
        response.headers['Access-Control-Allow-Headers'] = '*'
        response.headers['Access-Control-Allow-Methods'] = 'DELETE, GET, POST'

        halt 200
      end
      authorize_request
    end

    def current_user
      User.find_by(id: session[:user_id])
    end

    def unauthorized?
      request.get_header('HTTP_AUTHORIZATION') != "Bearer #{ENV['API_KEY']}"
    end

    def authorize_request
      halt 401 if unauthorized?
    end

    # def require_auth
    #   redirect '/sessions/new' unless current_user
    # end

    # def authenticate_user(login, password)
    #   user = User.find_by(login: login)
    #   return unless user&.valid_password?(password)

    #   session[:user_id] = user.id
    #   user
    # end

    run! if app_file == $PROGRAM_NAME
  end
end
