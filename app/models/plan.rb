# frozen_string_literal: true

class Plan < ApplicationRecord
  has_many :subscriptions

  validates :name, :price_in_cents, presence: true
end
