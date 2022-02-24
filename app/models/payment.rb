# frozen_string_literal: true

class Payment < ApplicationRecord
  encrypts :token

  belongs_to :subscription

  validates :amount, presence: true
end
