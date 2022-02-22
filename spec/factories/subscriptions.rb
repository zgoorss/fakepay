# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    association :customer
    association :plan

    expires_at { Date.today + 1.month }
    active { true }
  end
end
