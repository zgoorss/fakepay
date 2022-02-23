# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :customer
  belongs_to :plan
  has_many :payments

  validates :expires_at, :active, presence: true
end
