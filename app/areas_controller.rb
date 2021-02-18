# frozen_string_literal: true

require_relative 'application_controller'

module App
  class AreasController < ApplicationController
    before { authorize(current_user) }

    get '/' do
      Rollbar.info("GET AREAS. CURRENT_USER: #{current_user.id}")
      return_success(areas: Area.fetch_for_user(current_user.id))
    end

    post '/' do
      area = current_user.areas.create(params[:area])
      area.persisted? ? return_success(area: area.represent) : return_errors(area.errors.messages)
    end

    delete '/:id' do
      area = current_user.areas.find(params[:id])
      area.destroy
      return_success
    end
  end
end
