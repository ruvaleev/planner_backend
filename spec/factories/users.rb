# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    password { FFaker::Internet.password }
  end

  factory :demo_user, parent: :user do
    email { 'demo@user.com' }
    password { 'demo_password' }
  end
end
