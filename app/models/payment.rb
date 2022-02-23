# frozen_string_literal: true

class Payment < ApplicationRecord
  belongs_to :subscription

  enum status: { completed: 0, failed: 1 }
  validates :amount, :status, :payload, presence: true
end
