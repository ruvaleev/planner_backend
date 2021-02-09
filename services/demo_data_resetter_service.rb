# frozen_string_literal: true

class DemoDataResetterService
  attr_accessor :areas, :areas_params, :user, :user_params

  def initialize
    @user_params = parse_json('./services/demo_datas/demo_user.json')
    @areas_params = parse_json('./services/demo_datas/demo_areas.json')
    @user, @areas = nil
  end

  def run
    create_demo_user_if_absent
    reset_demo_areas
    create_todos
  end

  private

  def create_demo_user_if_absent
    @user = User.find_by(email: user_params[:email]) || User.create(user_params)
  end

  def reset_demo_areas
    user.areas.map(&:destroy)
    @areas = areas_params.each_with_object([]) do |area, result|
      result << Area.create(user: user, title: area[:title])
    end
  end

  def create_todos
    areas.each { |area| create_todos_for_area(area) }
  end

  def create_todos_for_area(area)
    todos_params = areas_params.find { |params| params[:title] == area.title }[:todos]
    todos_params.each { |todo| area.todos.create(title: todo) }
  end

  def parse_json(file_path)
    json = JSON.parse(File.read(file_path))
    json.is_a?(Array) ? json.map(&:with_indifferent_access) : json.with_indifferent_access
  end
end
