# frozen_string_literal: true

FactoryBot.define do
  factory :plan do
    name { 'Plan 1' }
    price_in_cents { 999 }
  end
end
