# frozen_string_literal: true

class User < ActiveRecord::Base
  has_many :areas, dependent: :destroy
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true

  before_validation :encrypt_password, if: :password_changed?

  def valid_password?(input)
    return unless password

    BCrypt::Password.new(password) == input
  end

  private

  def encrypt_password
    errors.add(:password, :blank) if password.blank?

    self.password = BCrypt::Password.create(password)
  end
end
