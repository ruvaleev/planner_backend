# frozen_string_literal: true

class Todo < ActiveRecord::Base
  belongs_to :area
  validates :title, presence: true
end
