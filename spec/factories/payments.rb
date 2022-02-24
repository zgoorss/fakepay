# frozen_string_literal: true

FactoryBot.define do
  factory :payment do
    association :subscription
    token { SecureRandom.base58(24) }
    amount { 1000 }
  end
end
