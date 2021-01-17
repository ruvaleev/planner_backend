# frozen_string_literal: true

require_relative 'application_controller'

module App
  class AreasController < ApplicationController
    get '/' do
      authorize(current_user)

      return_success(areas: Area.fetch_for_user(current_user.id))
    end
  end
end
