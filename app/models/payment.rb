# frozen_string_literal: true

class Payment < ApplicationRecord
  belongs_to :customer

  validates :token, presence: true
end
