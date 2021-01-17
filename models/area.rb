# frozen_string_literal: true

class Area < ActiveRecord::Base
  belongs_to :user
  has_many :todos, dependent: :destroy
  validates :title, presence: true

  def represent
    {
      id: id,
      title: title,
      created_at: created_at,
      todos: todos.map(&:represent)
    }
  end

  def self.fetch_for_user(user_id)
    includes(:todos).where(user_id: user_id).map(&:represent)
  end
end
