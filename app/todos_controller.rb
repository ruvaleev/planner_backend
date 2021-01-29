# frozen_string_literal: true

require_relative 'application_controller'

module App
  class TodosController < ApplicationController
    before { authorized_current_user_and_find_area }

    post '/' do
      todo = @area.todos.create(params[:todo])
      todo.persisted? ? return_success(todo: todo) : return_errors(todo.errors.messages)
    end

    patch '/:id' do
      todo = @area.todos.find(params[:id])
      todo.update(params[:todo]) ? return_success(todo: todo) : return_errors(todo.errors.messages)
    end

    delete '/:id' do
      todo = @area.todos.find(params[:id])
      todo.destroy
      return_success
    end

    private

    def authorized_current_user_and_find_area
      authorize(current_user)
      @area = current_user.areas.find(params[:area_id])
    end
  end
end
