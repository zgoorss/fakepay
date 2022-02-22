# frozen_string_literal: true

FactoryBot.define do
  factory :customer do
    name { 'Customer name' }
    address { 'Street 1' }
    zip_code { '001' }
  end
end
