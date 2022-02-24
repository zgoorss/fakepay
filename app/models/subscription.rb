# frozen_string_literal: true

class Subscription < ApplicationRecord
  VALIDITY_DATE = 1.month

  belongs_to :customer
  belongs_to :plan
  has_many :payments, dependent: :delete_all

  validates :expires_at, presence: true

  scope :expired, -> { where('expires_at <= ?', Date.today) }
  scope :inactive, -> { where(active: false) }

  def new_expires_at_date
    expires_at + VALIDITY_DATE
  end
end
