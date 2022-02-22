# frozen_string_literal: true

class Customer < ApplicationRecord
  validates :name, :address, :zip_code, presence: true
end
