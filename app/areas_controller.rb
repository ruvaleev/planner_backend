# frozen_string_literal: true

require_relative 'application_controller'

module App
  class AreasController < ApplicationController
    get '/' do
      authorize(current_user)

      return_success(areas: Area.fetch_for_user(current_user.id))
    end

    post '/' do
      authorize(current_user)
      area = current_user.areas.create(params[:area])
      area.persisted? ? return_success(areas: [area]) : return_errors(area.errors.messages)
    end

    delete '/' do
      authorize(current_user)
      area = current_user.areas.find_by(id: params[:id])

      return_not_found if area.blank?

      area.destroy
      return_success
    end
  end
end
