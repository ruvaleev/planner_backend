# frozen_string_literal: true

FactoryBot.define do
  factory :area do
    association :user
    title { FFaker::Lorem.phrase }
  end
end
