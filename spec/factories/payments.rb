# frozen_string_literal: true

FactoryBot.define do
  factory :payment do
    association :customer
    token { SecureRandom.base58(24) }
  end
end
