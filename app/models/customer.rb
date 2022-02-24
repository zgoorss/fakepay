# frozen_string_literal: true

class Customer < ApplicationRecord
  has_many :subscriptions
  has_many :payments, through: :subscriptions

  validates :name, :address, :zip_code, presence: true
end
