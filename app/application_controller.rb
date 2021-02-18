# frozen_string_literal: true

require 'rollbar/middleware/sinatra'
require 'sinatra/base'
require 'sinatra/reloader' if development?

require_relative 'helpers/response_helpers'

module App
  class ApplicationController < Sinatra::Base
    use Rollbar::Middleware::Sinatra

    configure do
      use Rack::Session::Cookie, key: 'rack.session',
                                 path: '/',
                                 same_site: :none,
                                 secret: 'some secret key',
                                 secure: true
    end
    configure :production, :development do
      enable :logging
    end
    configure :development do
      register Sinatra::Reloader
    end

    set show_exceptions: false

    before do
      response.headers['Access-Control-Allow-Origin'] = allowed_origin
      response.headers['Access-Control-Allow-Credentials'] = 'true'
      if request.request_method == 'OPTIONS'
        response.headers['Access-Control-Allow-Headers'] = 'authorization, content-type'
        response.headers['Access-Control-Allow-Methods'] = 'DELETE, GET, PATCH, POST'

        halt 200
      end
      authorize_request
    end

    error ActiveRecord::RecordNotFound do
      return_not_found
    end

    error do
      500
    end

    private

    def allowed_origin
      ENV['ORIGINS_URLS'].split(', ').find { |origin| origin == request.env['HTTP_ORIGIN'] } || ''
    end

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
