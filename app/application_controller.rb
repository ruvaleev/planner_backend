# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/reloader' if development?

require_relative 'helpers/response_helpers'

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

    private

    def authorize(condition)
      return_unauthorized unless condition
    end

    def authorize_request
      authorize(request.get_header('HTTP_AUTHORIZATION') == "Bearer #{ENV['API_KEY']}")
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end

    def save_user_id_to_session(user_id)
      session[:user_id] = user_id
    end

    run! if app_file == $PROGRAM_NAME
  end
end
