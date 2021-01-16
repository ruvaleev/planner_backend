# frozen_string_literal: true

class Area < ActiveRecord::Base
  belongs_to :user
  has_many :todos, dependent: :destroy
  validates :title, presence: true
end
