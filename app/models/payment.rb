# frozen_string_literal: true

class Payment < ApplicationRecord
  belongs_to :subscription

  validates :amount, presence: true
end
