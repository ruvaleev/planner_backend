# frozen_string_literal: true

class Todo < ActiveRecord::Base
  belongs_to :area
  validates :title, presence: true

  def represent
    {
      id: id,
      title: title,
      completed: completed,
      created_at: created_at
    }
  end
end
