# frozen_string_literal: true

FactoryBot.define do
  factory :todo do
    association :area
    title { FFaker::Lorem.phrase }
    completed { [true, false].sample }
  end
end
