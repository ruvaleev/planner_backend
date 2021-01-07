# frozen_string_literal: true

class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true
  before_validation :encrypt_password, if: :password_changed?

  def valid_password?(input)
    return unless password

    BCrypt::Password.new(password) == input
  end

  private

  def encrypt_password
    self.password = BCrypt::Password.create(password)
  end
end
