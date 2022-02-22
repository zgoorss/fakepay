# frozen_string_literal: true

class Payment < ApplicationRecord
  belongs_to :customer

  validates :customer_id, :token, presence: true
end
