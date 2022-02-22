# frozen_string_literal: true

class Plan < ApplicationRecord
  validates :name, :price, presence: true
end
